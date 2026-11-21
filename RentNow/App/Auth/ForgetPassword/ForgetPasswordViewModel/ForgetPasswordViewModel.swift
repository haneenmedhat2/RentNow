//
//  LoginViewModel.swift
//  Holool
//
//  Created by Elshamy on 03/11/2025.
//

import Foundation
import Combine

class ForgetPasswordViewModel: BaseViewModel {

    @Published var countriesArray: [Country] = []

    // MARK: - Inputs
    @Published var phoneNumber: String = ""
    @Published var countryCode: Country? = nil

    // MARK: - Errors
    @Published var phoneError: String? = nil
    @Published var countryCodeError: String? = nil

    override init(responseHandler: any ResponseHandler = DefaultResponseHandler()) {
        super.init(responseHandler: responseHandler)
        getCountries()
    }

    @MainActor func callApi() {
        // Validate all fields using isolated validation logic
        let errors = ForgetPasswordValidation.validateForgetPasswordForm(
            phone: phoneNumber,
            countryCode: countryCode
        )

        // Update error states
        phoneError = errors.phoneError
        countryCodeError = errors.countryCodeError

        // If any validation failed, stop here
        // NO Toast for validation errors
        guard errors.phoneError == nil &&
              errors.countryCodeError == nil else {
            return
        }

        // Proceed with API call
        forgetPasswordSendCodeApi()
    }
    
    // MARK: - Networking
    @MainActor
    private func forgetPasswordSendCodeApi() {
        Task {
            showIndicator()
            let formattedPhone = PhoneTextView.formatPhoneForApi(phoneNumber, countryCode: countryCode?.key)
            let countryCodeKey = PhoneTextView.getCountryCodeOrDefault(countryCode)
            let endPoint = AuthEndpoint.forgotPassword(countryCode: countryCodeKey, phone: formattedPhone)

            do {
                let response = try await requestFullResponse(endPoint)

                showSuccess(response.message)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.successMessage = response.message
                }
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }
    
    func getCountries() {
        Task {
            showIndicator()
            let endPoint = AuthEndpoint.registrationFormData()

            do {
                let response = try await requestFullResponse(endPoint)
                guard let data = response.data else { return }
                await MainActor.run {
                    self.countriesArray = data.toCountries()
                    // Set default country code to first country (Saudi Arabia +966)
                    if let defaultCountry = self.countriesArray.first(where: { $0.key == "+966" }) ?? self.countriesArray.first {
                        self.countryCode = defaultCountry
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
