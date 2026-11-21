//
//  MyWalletViewModel.swift
//  RentNow
//

import Foundation
import Combine

@MainActor
final class MyWalletViewModel: BaseViewModel {

    @Published var balance: Double = 0
    @Published var paymentSession: PaymentSession?
    private var isStartingCharge = false

    // MARK: - Load Balance
    func fetchBalance() async {
        showIndicator()
        do {
            let response = try await requestFullResponse(MoreEndpoint.getWalletAmount())
            if response.key == .success {
                balance = response.data ?? 0
            } else {
                showError(response.message)
            }
        } catch {
            showError(error.localizedDescription)
        }
        hideIndicator()
    }

    // MARK: - Recharge
    func chargeWallet(amount: Double, paymentMethod: Int = 1, moyasarMethod: MoyasarPaymentMethod = .card) {
        guard !isStartingCharge, amount.isFinite, amount > 0, [1, 2, 4].contains(paymentMethod) else { return }
        guard paymentMethod != 1 || moyasarMethod != .applePay || MoyasarConfiguration.canUseApplePay else {
            showError("Apple Pay is currently unavailable.".localized)
            return
        }
        isStartingCharge = true
        Task {
            showIndicator()
            var openedCheckout = false
            defer {
                hideIndicator()
                if !openedCheckout { isStartingCharge = false }
            }
            do {
                if paymentMethod == 2 || paymentMethod == 4 {
                    // Check the exact submitted amount again before creating a charge.
                    let eligibility = try await request(PaymentEndpoint.checkInstallmentEligibility(amount: amount, paymentMethod: paymentMethod))
                    guard let eligibility, abs(eligibility.amount - amount) < 0.005,
                          eligibility.currency.uppercased() == "SAR",
                          let option = eligibility.options.first(where: { $0.id == paymentMethod }) else {
                        showError("Invalid payment response".localized)
                        return
                    }
                    guard option.isAvailable == true else {
                        showError(option.unavailableReason.flatMap { $0.isEmpty ? nil : $0 } ?? "This payment method is currently unavailable.".localized)
                        return
                    }
                }
                guard let payment = try await request(MoreEndpoint.chargeWallet(amount: amount, paymentMethod: paymentMethod)) else {
                    showError("Invalid payment response".localized)
                    return
                }
                let session: PaymentSession?
                switch paymentMethod {
                case 4:
                    session = PaymentSession(tabbyPayment: payment, kind: .wallet)
                case 2:
                    session = PaymentSession(tamaraPayment: payment, kind: .wallet)
                default:
                    guard payment.provider == nil || payment.provider == .moyasar else {
                        showError("Invalid payment response".localized)
                        return
                    }
                    session = PaymentSession(moyasarPayment: payment, kind: .wallet, method: moyasarMethod)
                }
                guard let session else {
                    let message = [payment.tamara?.rejectionMessage, payment.tabby?.rejectionMessage, payment.message]
                        .compactMap { $0 }.first { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
                    showError(message ?? "Invalid payment response".localized)
                    return
                }
                openedCheckout = true
                paymentSession = session
            } catch {
                showError(error.localizedDescription)
            }
        }
    }

    func handlePaymentResult(_ result: PaymentResult) {
        isStartingCharge = false
        switch result {
        case .paid:
            Task {
                await fetchBalance()
                showSuccess("Balance recharged successfully".localized)
            }
        case .failed(let message):
            showError(message ?? "Payment failed".localized)
        case .canceled:
            break
        case .expired(let message):
            showError(message ?? "Payment expired".localized)
        case .needsReview(let message):
            showInfo(message ?? "Your payment is under review.".localized)
        case .pending:
            showInfo("Payment is still pending. Please check your wallet later.".localized)
        }
    }

    // MARK: - Withdraw Request
    func createWithdrawRequest(
        amount: Double,
        iban: String,
        accountName: String,
        accountNumber: String,
        bankName: String
    ) {
        Task {
            showIndicator()
            do {
                let response = try await requestFullResponse(
                    MoreEndpoint.createWalletWithdrawRequest(
                        amount: amount,
                        iban: iban,
                        accountName: accountName,
                        accountNumber: accountNumber,
                        bankName: bankName
                    )
                )
                if response.key == .success {
                    showSuccess("Withdraw request submitted successfully".localized)
                    await fetchBalance()
                } else {
                    showError(response.message)
                }
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }
}
