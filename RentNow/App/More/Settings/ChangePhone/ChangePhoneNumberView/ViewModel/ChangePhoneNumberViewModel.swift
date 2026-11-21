//
//  ChangePhoneNumberViewModel.swift
//  RentNow
//
//  Created by Elshamy on 12/02/2026.
//

import SwiftUI
import Combine

final class ChangePhoneNumberViewModel: BaseViewModel {

    @Published var phone: String = ""
    @Published var phoneError: String? = nil
    @Published var hasEditedPhone: Bool = false
    @Published var countryCode: Country? = nil
    @Published var countriesArray: [Country] = []

    // MARK: - Validation

    private func validatePhone() -> Bool {
        if phone.isEmpty {
            phoneError = "Please enter your phone number".localized
            return false
        }
        if phone.count < 9 {
            phoneError = "Please enter a valid phone number".localized
            return false
        }
        phoneError = nil
        return true
    }

    // MARK: - Get Countries

    func getCountries() {
        Task {
            showIndicator()
            let endpoint = AuthEndpoint.registrationFormData()
            do {
                let data = try await request(endpoint)
                await MainActor.run {
                    if let formData = data {
                        self.countriesArray = formData.toCountries()
                        if self.countryCode == nil {
                            self.countryCode = self.countriesArray.first(where: { $0.key == "+966" }) ?? self.countriesArray.first
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    showError(error.localizedDescription)
                }
            }
            hideIndicator()
        }
    }

    // MARK: - API: Request Change Phone

    func requestChangePhoneApi() {
        guard validatePhone() else { return }
        Task {
            showIndicator()
            let phoneCode = PhoneTextView.getCountryCodeOrDefault(countryCode)
            let phoneNumber = PhoneTextView.formatPhoneForApi(phone, countryCode: countryCode?.key)
            let endpoint = MoreEndpoint.requestChangePhone(phoneCode: phoneCode, newPhoneNumber: phoneNumber)
            do {
                let response = try await requestFullResponse(endpoint)
                await MainActor.run {
                    showSuccess(response.message)
                    self.successMessage = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                        self?.successMessage = response.message
                    }
                }
            } catch {
                await MainActor.run {
                    showError(error.localizedDescription)
                }
            }
            hideIndicator()
        }
    }
}
