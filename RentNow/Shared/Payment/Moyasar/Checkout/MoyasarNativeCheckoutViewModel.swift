import Foundation
import Combine
import MoyasarSdk
import PassKit

@MainActor
final class MoyasarNativeCheckoutViewModel: BaseViewModel {
    @Published private(set) var result: PaymentResult?
    @Published private(set) var isVerifying = false
    let session: PaymentSession
    let paymentRequest: MoyasarSdk.PaymentRequest?
    private var task: Task<Void, Never>?
    private var applePayHandler: MoyasarApplePayHandler?
    private var hasStarted = false

    private var attemptStore: MoyasarAttemptStore? {
        session.moyasar.map { MoyasarAttemptStore(attemptId: $0.attemptId) }
    }
    private var canPresentPayment: Bool {
        paymentRequest != nil && (session.moyasar?.method != .applePay || MoyasarConfiguration.canUseApplePay)
    }

    init(session: PaymentSession) {
        self.session = session
        if let payment = session.moyasar {
            self.paymentRequest = try? MoyasarSdk.PaymentRequest(
                apiKey: MoyasarConfiguration.publishableKey,
                amount: payment.amountHalalas,
                currency: payment.currency,
                description: "RentNow payment #\(session.transactionId)",
                metadata: ["transactionId": .stringValue(session.transactionId)],
                givenID: payment.attemptId
            )
        } else {
            self.paymentRequest = nil
        }
        super.init()
    }

    func start() {
        guard !hasStarted else { return }
        hasStarted = true
        guard canPresentPayment, let payment = session.moyasar else {
            result = .failed(message: "Payment is unavailable. Please contact support.".localized)
            return
        }
        // Old markers can represent an actual submission and must stay conservative.
        if attemptStore?.hasSubmitted == true {
            verify(paymentId: payment.attemptId, confirm: false)
        } else if payment.isExpired {
            verify(paymentId: payment.attemptId, confirm: false)
        } else if payment.method == .applePay, let request = paymentRequest {
            startApplePay(request: request)
        }
    }

    func paymentWillStart() -> Bool {
        guard result == nil, !isVerifying else { return false }
        attemptStore?.markSubmitted()
        return true
    }

    func handleSDKResult(_ sdkResult: MoyasarSdk.PaymentResult) {
        guard let payment = session.moyasar else { return }
        guard attemptStore?.hasSubmitted == true else {
            finish(.failed(message: "Payment is unavailable. Please contact support.".localized))
            return
        }
        let id: String
        switch sdkResult {
        case .completed(let result):
            id = result.id
            #if DEBUG
            print("Moyasar SDK: completed, status=\(result.status.rawValue), paymentIdMatchesAttempt=\(result.id.caseInsensitiveCompare(payment.attemptId) == .orderedSame)")
            #endif
        case .failed(let error):
            switch error {
            case .webviewTimedOut(let result):
                id = result.id
                #if DEBUG
                print("Moyasar SDK: 3DS navigation timed out")
                #endif
            case .webviewNotConnectedToInternet(let result):
                id = result.id
                #if DEBUG
                print("Moyasar SDK: 3DS connection unavailable")
                #endif
            case .webviewUnexpectedError(let result, let underlying):
                id = result.id
                #if DEBUG
                let error = underlying as NSError
                print("Moyasar SDK: 3DS navigation failed, domain=\(error.domain), code=\(error.code)")
                #endif
            default:
                id = payment.attemptId
                #if DEBUG
                print("Moyasar SDK: payment submission failed before a 3DS result")
                #endif
            }
        case .canceled, .saveOnlyToken:
            id = payment.attemptId
            #if DEBUG
            print("Moyasar SDK: payment canceled or token-only result")
            #endif
        @unknown default: id = payment.attemptId
        }
        verify(paymentId: id, confirm: true)
    }

    func startApplePay(request: MoyasarSdk.PaymentRequest) {
        guard result == nil, !isVerifying else { return }
        let handler = MoyasarApplePayHandler(request: request, merchantID: MoyasarConfiguration.merchantID, onPaymentStarted: { [weak self] in
            self?.paymentWillStart() ?? false
        }) { [weak self] id in
            guard let self, let attempt = self.session.moyasar else { return }
            if self.attemptStore?.hasSubmitted == true {
                self.verify(paymentId: id ?? attempt.attemptId, confirm: true)
            } else {
                self.finish(.canceled(message: nil))
            }
        }
        applePayHandler = handler
        handler.present()
    }

    func close() {
        guard result == nil else { return }
        if isVerifying {
            task?.cancel()
            finish(.pending)
            return
        }
        if canPresentPayment, let payment = session.moyasar, attemptStore?.hasSubmitted == true {
            verify(paymentId: payment.attemptId, confirm: true)
        } else if canPresentPayment {
            finish(.canceled(message: nil))
        } else {
            result = .failed(message: "Payment is unavailable. Please contact support.".localized)
        }
    }

    func stop() { task?.cancel() }

    private func verify(paymentId: String, confirm: Bool) {
        guard !isVerifying, result == nil else { return }
        isVerifying = true
        task = Task {
            let deadline = Date().addingTimeInterval(60)
            if confirm {
                if let data = try? await request(PaymentEndpoint.confirmMoyasar(transactionId: session.transactionId, paymentId: paymentId, timeoutInterval: 8)),
                   let terminal = terminalResult(data) {
                    finish(terminal)
                    return
                }
            }
            while Date() < deadline {
                guard !Task.isCancelled else { return }
                let timeout = max(0.1, min(8, deadline.timeIntervalSinceNow))
                if let data = try? await request(PaymentEndpoint.getOrderStatus(transactionId: session.transactionId, timeoutInterval: timeout)),
                   let terminal = terminalResult(data) {
                    finish(terminal)
                    return
                }
                let remaining = deadline.timeIntervalSinceNow
                guard remaining > 0 else { break }
                do { try await Task.sleep(nanoseconds: UInt64(min(3, remaining) * 1_000_000_000)) } catch { return }
            }
            finish(.pending)
        }
    }

    private func terminalResult(_ data: OrderPaymentStatusData) -> PaymentResult? {
        guard session.matches(data) else { return nil }
        let message = data.paymentStatusText.flatMap { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : $0 }
        switch data.paymentStatus {
        case .paid: return .paid
        case .rejected: return .failed(message: message)
        case .cancelled: return .canceled(message: message)
        case .expired: return .expired(message: message)
        case .needsReview: return .needsReview(message: "Payment received, under review. Support will contact you.".localized)
        case .refunded: return .failed(message: message ?? "This payment has been refunded.".localized)
        case .pending, .unpaid, .unknown, nil: return nil
        }
    }

    private func finish(_ result: PaymentResult) {
        guard self.result == nil else { return }
        if result != .pending { attemptStore?.clear() }
        isVerifying = false
        self.result = result
    }
}

@MainActor
final class MoyasarApplePayHandler: NSObject, PKPaymentAuthorizationControllerDelegate {
    private let request: MoyasarSdk.PaymentRequest
    private let merchantID: String
    private let completion: (String?) -> Void
    private let onPaymentStarted: () -> Bool
    private var controller: PKPaymentAuthorizationController?
    private var paymentID: String?
    private var didFinish = false

    init(request: MoyasarSdk.PaymentRequest, merchantID: String, onPaymentStarted: @escaping () -> Bool, completion: @escaping (String?) -> Void) {
        self.request = request
        self.merchantID = merchantID
        self.onPaymentStarted = onPaymentStarted
        self.completion = completion
    }

    func present() {
        let payment = PKPaymentRequest()
        payment.merchantIdentifier = merchantID
        payment.countryCode = "SA"
        payment.currencyCode = request.currency
        payment.supportedNetworks = [.mada, .visa, .masterCard]
        payment.merchantCapabilities = [.capability3DS, .capabilityCredit, .capabilityDebit]
        let amount = NSDecimalNumber(value: request.amount).dividing(by: NSDecimalNumber(value: 100))
        payment.paymentSummaryItems = [PKPaymentSummaryItem(label: "RentNow", amount: amount)]
        let controller = PKPaymentAuthorizationController(paymentRequest: payment)
        self.controller = controller
        controller.delegate = self
        controller.present { [weak self] presented in
            guard !presented else { return }
            #if DEBUG
            print("Apple Pay: payment sheet could not be presented")
            #endif
            Task { @MainActor in self?.finish() }
        }
    }

    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler: @escaping (PKPaymentAuthorizationResult) -> Void) {
        Task {
            do {
                let service = try ApplePayService(apiKey: request.apiKey)
                guard onPaymentStarted() else {
                    handler(PKPaymentAuthorizationResult(status: .failure, errors: nil))
                    return
                }
                let response = try await service.authorizePayment(request: request, token: payment.token)
                paymentID = response.id
                guard response.status == .paid else {
                    let message: String?
                    if case let .applePay(source) = response.source {
                        message = source.message
                    } else {
                        message = nil
                    }
                    let errors: [Error]? = message.map {
                        [NSError(domain: "MoyasarApplePay", code: 1, userInfo: [NSLocalizedDescriptionKey: $0])]
                    }
                    #if DEBUG
                    print("Apple Pay: Moyasar authorization returned status \(response.status.rawValue)")
                    #endif
                    handler(PKPaymentAuthorizationResult(status: .failure, errors: errors))
                    return
                }
                handler(PKPaymentAuthorizationResult(status: .success, errors: nil))
            } catch {
                #if DEBUG
                print("Apple Pay: Moyasar authorization failed: \(error.localizedDescription)")
                #endif
                handler(PKPaymentAuthorizationResult(status: .failure, errors: [error]))
            }
        }
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss { [weak self] in Task { @MainActor in self?.finish() } }
    }

    private func finish() {
        guard !didFinish else { return }
        didFinish = true
        completion(paymentID)
    }
}
