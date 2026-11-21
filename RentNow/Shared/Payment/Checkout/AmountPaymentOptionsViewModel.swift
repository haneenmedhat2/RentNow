import Foundation
import Combine

@MainActor
final class AmountPaymentOptionsViewModel: BaseViewModel {
    @Published var amount = "" {
        didSet {
            guard amount != oldValue else { return }
            eligibilityRevision += 1
            paymentOptions = [Self.onlineOption]
            selectedMethodId = 1
            eligibilityError = nil
            isCheckingEligibility = validAmount != nil
        }
    }
    @Published var moyasarMethod: MoyasarPaymentMethod = .card
    @Published var selectedMethodId: Int? = 1
    @Published private(set) var paymentOptions: [OrderPaymentOption] = [onlineOption]
    @Published private(set) var isCheckingEligibility = false
    @Published private(set) var eligibilityError: String?

    private var eligibilityRevision = 0

    private static var onlineOption: OrderPaymentOption {
        OrderPaymentOption(id: 1, name: "Online".localized, isAvailable: true)
    }

    var validAmount: Double? {
        let normalized = amount.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "٫", with: ".")
            .replacingOccurrences(of: ",", with: ".")
            .map { character in character.wholeNumberValue.map(String.init) ?? String(character) }.joined()
        guard let value = Double(normalized), value.isFinite, value > 0,
              value <= Double(Int.max) / 100,
              abs(value * 100 - (value * 100).rounded()) < 0.000001 else { return nil }
        return value
    }

    var canConfirm: Bool {
        validAmount != nil && !isCheckingEligibility &&
        (selectedMethodId != 1 || moyasarMethod != .applePay || MoyasarConfiguration.canUseApplePay) &&
        OrderPaymentOption.validSelection(selectedMethodId, in: paymentOptions) != nil
    }

    func selectMethod(_ id: Int) {
        selectedMethodId = OrderPaymentOption.validSelection(id, in: paymentOptions)
    }

    /// Called by SwiftUI's amount-keyed task, which cancels superseded checks.
    func checkEligibility() async {
        guard let value = validAmount else { return }
        eligibilityRevision += 1
        let revision = eligibilityRevision
        isCheckingEligibility = true
        eligibilityError = nil
        // Wallet charges and package payments only offer installments from 1,000 SAR.
        guard value >= 1_000 else {
            paymentOptions = [Self.onlineOption]
            selectedMethodId = 1
            isCheckingEligibility = false
            return
        }
        do {
            try await Task.sleep(nanoseconds: 400_000_000)
            let data = try await request(PaymentEndpoint.checkInstallmentEligibility(amount: value))
            guard !Task.isCancelled, revision == eligibilityRevision, validAmount == value else { return }
            guard let data, abs(data.amount - value) < 0.005, data.currency.uppercased() == "SAR" else {
                throw ResponseError.server(message: "Invalid payment response".localized)
            }
            paymentOptions = [Self.onlineOption] + OrderPaymentOption.selectableOptions(data.options).filter { $0.id == 2 || $0.id == 4 }
            selectedMethodId = OrderPaymentOption.validSelection(selectedMethodId, in: paymentOptions) ?? 1
        } catch {
            guard !Task.isCancelled, revision == eligibilityRevision, validAmount == value else { return }
            paymentOptions = [Self.onlineOption]
            selectedMethodId = 1
            eligibilityError = error.localizedDescription
        }
        isCheckingEligibility = false
    }
}
