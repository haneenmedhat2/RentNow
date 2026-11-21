//
//  PackagesListViewModel.swift
//  RentNow
//
//  Created by Claude on 2026-02-08.
//

import Foundation
import Combine

@MainActor
class PackagesListViewModel: BaseViewModel {

    @Published var packages: [PackageItem] = []
    @Published var paymentSession: PaymentSession?
    @Published var isSubscribed = false
    @Published private(set) var isStartingPayment = false

    func fetchPackages() {
        Task {
            showIndicator()
            let endpoint = WalletEndpoint.getActivePackages()
            do {
                let data = try await request(endpoint)
                self.packages = data ?? []
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }

    func subscribe(packageId: Int, paymentMethod: Int = 1, moyasarMethod: MoyasarPaymentMethod = .card) {
        guard !isStartingPayment, [1, 2, 4].contains(paymentMethod),
              let package = packages.first(where: { $0.id == packageId }),
              let price = package.price, price.isFinite, price > 0 else { return }
        guard paymentMethod != 1 || moyasarMethod != .applePay || MoyasarConfiguration.canUseApplePay else {
            showError("Apple Pay is currently unavailable.".localized)
            return
        }
        isStartingPayment = true
        Task {
            showIndicator()
            var openedCheckout = false
            defer {
                hideIndicator()
                if !openedCheckout { isStartingPayment = false }
            }
            do {
                if paymentMethod == 2 || paymentMethod == 4 {
                    let eligibility = try await request(PaymentEndpoint.checkInstallmentEligibility(amount: price, paymentMethod: paymentMethod))
                    guard let eligibility, abs(eligibility.amount - price) < 0.005,
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
                guard let response = try await request(WalletEndpoint.subscribe(packageId: packageId, paymentMethod: paymentMethod)) else {
                    showError("Invalid payment response".localized)
                    return
                }
                let payment = response.payment
                let session: PaymentSession?
                switch paymentMethod {
                case 4: session = PaymentSession(tabbyPayment: payment, kind: .package)
                case 2: session = PaymentSession(tamaraPayment: payment, kind: .package)
                default:
                    guard payment.provider == nil || payment.provider == .moyasar else {
                        showError("Invalid payment response".localized)
                        return
                    }
                    session = PaymentSession(moyasarPayment: payment, kind: .package, method: moyasarMethod)
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
        isStartingPayment = false
        switch result {
        case .paid:
            isSubscribed = true
        case .failed(let message):
            showError(message ?? "Payment failed".localized)
        case .canceled:
            break
        case .expired(let message):
            showError(message ?? "Payment expired".localized)
        case .needsReview(let message):
            showInfo(message ?? "Your payment is under review.".localized)
        case .pending:
            showInfo("Payment is still pending. Please check your subscription later.".localized)
        }
    }

    func durationText(for package: PackageItem) -> String {
        guard let days = package.durationInDays, days > 0 else { return "" }
        let months = days / 30
        if months == 1 {
            return "1 month".localized
        }
        if months > 0 {
            return String(format: "%d months".localized, months)
        }
        return "\(days) " + "days".localized
    }
}
