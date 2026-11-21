import Foundation
import Combine
import Tabby

@MainActor
final class TabbyCheckoutViewModel: BaseViewModel {
    @Published private(set) var result: PaymentResult?
    @Published private(set) var isCheckingStatus = false
    @Published private(set) var hasStatusConnectionIssue = false
    @Published private(set) var isClosing = false

    let session: PaymentSession

    private var completionTask: Task<Void, Never>?
    private var consecutiveFailures = 0

    init(session: PaymentSession) {
        self.session = session
        super.init()
    }

    func stop() {
        completionTask?.cancel()
        isCheckingStatus = false
    }

    func closePayment() {
        handleTabbyResult(.close)
    }

    func handleTabbyResult(_ result: TabbyResult) {
        guard !isClosing, self.result == nil else { return }
        isClosing = true
        completionTask = Task {
            let attempts = result == .authorized ? 5 : 1
            for attempt in 0..<attempts {
                if Task.isCancelled || self.result != nil { return }
                let confirmed = await finalResultBeforeClosing()
                guard !Task.isCancelled, self.result == nil else { return }
                if confirmed != .pending {
                    complete(with: confirmed)
                    return
                }
                if attempt + 1 < attempts {
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                }
            }
            switch result {
            case .authorized: complete(with: .pending)
            case .close: complete(with: .canceled(message: "You aborted the payment. Please retry or choose another payment method.".localized))
            case .rejected: complete(with: .failed(message: "Tabby could not approve this payment. Please choose another payment method.".localized))
            case .expired: complete(with: .expired(message: "Tabby session expired. Please try again to start a new session.".localized))
            }
        }
    }

    // MARK: - Backend verification

    private func finalResultBeforeClosing() async -> PaymentResult {
        isCheckingStatus = true
        let terminalResult = await fetchResult()
        isCheckingStatus = false
        return terminalResult ?? .pending
    }

    private func fetchResult() async -> PaymentResult? {
        do {
            let data = try await request(PaymentEndpoint.getOrderStatus(transactionId: session.transactionId))
            guard let data, session.matches(data) else {
                consecutiveFailures += 1
                hasStatusConnectionIssue = consecutiveFailures >= 2
                return nil
            }
            consecutiveFailures = 0
            hasStatusConnectionIssue = false
            switch data.paymentStatus {
            case .paid: return .paid
            case .rejected: return .failed(message: nonempty(data.paymentStatusText))
            case .cancelled: return .canceled(message: "You aborted the payment. Please retry or choose another payment method.".localized)
            case .expired: return .expired(message: nonempty(data.paymentStatusText))
            case .refunded: return .failed(message: "This payment has been refunded.".localized)
            case .needsReview: return .needsReview(message: nonempty(data.paymentStatusText))
            case .unpaid, .pending, .unknown, nil: return nil
            }
        } catch {
            guard !Task.isCancelled else { return nil }
            consecutiveFailures += 1
            hasStatusConnectionIssue = consecutiveFailures >= 2
            return nil
        }
    }

    private func nonempty(_ message: String?) -> String? {
        guard let message, !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }
        return message
    }

    private func complete(with result: PaymentResult) {
        guard self.result == nil else { return }
        self.result = result
    }

}
