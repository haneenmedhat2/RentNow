import Foundation
import Combine

@MainActor
final class TamaraCheckoutViewModel: BaseViewModel {
    @Published private(set) var result: PaymentResult?
    @Published private(set) var isVerifying = false

    let session: PaymentSession
    private var verificationTask: Task<Void, Never>?

    init(session: PaymentSession) {
        self.session = session
        super.init()
    }

    /// SDK callbacks are hints. Only the backend can confirm the payment.
    func verifyPayment(afterSuccess: Bool) {
        guard !isVerifying, result == nil else { return }
        isVerifying = true
        verificationTask = Task {
            defer { isVerifying = false }
            // The backend guide allows about 60 seconds for capture after success.
            let attempts = afterSuccess ? 20 : 1
            for attempt in 0..<attempts {
                guard !Task.isCancelled else { return }
                let confirmed = await fetchResult()
                guard !Task.isCancelled else { return }
                if let confirmed {
                    result = confirmed
                    return
                }
                if attempt + 1 < attempts {
                    do {
                        try await Task.sleep(nanoseconds: 3_000_000_000)
                    } catch {
                        return
                    }
                }
            }
            result = .pending
        }
    }

    func stop() {
        verificationTask?.cancel()
    }

    private func fetchResult() async -> PaymentResult? {
        do {
            let data = try await request(PaymentEndpoint.getOrderStatus(transactionId: session.transactionId))
            guard let data, session.matches(data) else { return nil }
            let message = data.paymentStatusText.flatMap {
                $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : $0
            }
            switch data.paymentStatus {
            case .paid: return .paid
            case .rejected: return .failed(message: message)
            case .cancelled: return .canceled(message: message)
            case .expired: return .expired(message: message)
            case .needsReview: return .needsReview(message: message)
            case .refunded: return .failed(message: message ?? "This payment has been refunded.".localized)
            case .unpaid, .unknown: return .pending
            case .pending, nil: return nil
            }
        } catch {
            // An unavailable status API must never turn an SDK callback into success.
            return nil
        }
    }
}
