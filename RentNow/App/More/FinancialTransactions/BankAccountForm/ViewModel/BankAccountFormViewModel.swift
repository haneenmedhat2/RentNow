//
//  BankAccountFormViewModel.swift
//  RentNow
//

import Foundation
import Combine

@MainActor
class BankAccountFormViewModel: BaseViewModel {

    // MARK: - Form Fields
    @Published var bankName: String = ""
    @Published var accountNumber: String = ""
    @Published var accountHolderName: String = ""
    @Published var iban: String = ""

    // MARK: - Errors
    @Published var bankNameError: String? = nil
    @Published var accountNumberError: String? = nil
    @Published var accountHolderNameError: String? = nil
    @Published var ibanError: String? = nil

    // MARK: - Callback
    var onSuccess: (() -> Void)?

    // MARK: - Validation
    private func validate() -> Bool {
        var isValid = true

        if bankName.trimmingCharacters(in: .whitespaces).isEmpty {
            bankNameError = "This field is required".localized
            isValid = false
        } else {
            bankNameError = nil
        }

        let trimmedAccount = accountNumber.trimmingCharacters(in: .whitespaces)
        if trimmedAccount.isEmpty {
            accountNumberError = "This field is required".localized
            isValid = false
        } else if trimmedAccount.count < 10 || trimmedAccount.count > 15 || !trimmedAccount.allSatisfy({ $0.isNumber }) {
            accountNumberError = "Account number must be 10-15 digits".localized
            isValid = false
        } else {
            accountNumberError = nil
        }

        if accountHolderName.trimmingCharacters(in: .whitespaces).isEmpty {
            accountHolderNameError = "This field is required".localized
            isValid = false
        } else {
            accountHolderNameError = nil
        }

        let trimmedIban = iban.trimmingCharacters(in: .whitespaces)
        if trimmedIban.isEmpty {
            ibanError = "This field is required".localized
            isValid = false
        } else {
            let ibanPattern = "^[A-Za-z]{2}[0-9]{22}$"
            if trimmedIban.range(of: ibanPattern, options: .regularExpression) == nil {
                ibanError = "IBAN must be 2 letters followed by 22 numbers".localized
                isValid = false
            } else {
                ibanError = nil
            }
        }

        return isValid
    }

    // MARK: - Submit
    func submitSettlement() {
        guard validate() else { return }

        Task {
            showIndicator()
            do {
                let endpoint = FinancialEndpoint.requestSettlement(
                    iban: iban,
                    accountName: accountHolderName,
                    accountNumber: accountNumber,
                    bankName: bankName
                )
                _ = try await request(endpoint)
                showSuccess("Settlement request sent successfully".localized)
                onSuccess?()
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }
}
