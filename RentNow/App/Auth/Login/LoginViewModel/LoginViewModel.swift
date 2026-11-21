//
//  LoginViewModel.swift
//  Holool
//
//  Created by Elshamy on 03/11/2025.
//

import Foundation
import Combine

// MARK: - Login Event
enum LoginEvent {
    case success
    case needsActivation(countryCode: String, phone: String)
}

class LoginViewModel: BaseViewModel {

    @Published var countriesArray: [Country] = []

    // MARK: - Inputs
    @Published var phoneNumber: String = ""
    @Published var password: String = ""
    @Published var countryCode: Country? = nil

    // MARK: - Errors (only these trigger error label updates)
    @Published var phoneError: String? = nil
    @Published var passwordError: String? = nil
    @Published var countryCodeError: String? = nil

    // MARK: - Events
    let loginEvent = PassthroughSubject<LoginEvent, Never>()

    override init(responseHandler: any ResponseHandler = DefaultResponseHandler()) {
        super.init(responseHandler: responseHandler)
        getCountries()
    }

  
    
    @MainActor func callApi() {
        // Validate all fields using isolated validation logic
        let errors = LoginValidation.validateLoginForm(
            phone: phoneNumber,
            password: password,
            countryCode: countryCode
        )

        // Update error states
        phoneError = errors.phoneError
        passwordError = errors.passwordError
        countryCodeError = errors.countryCodeError

        // If any validation failed, stop here
        // NO Toast for validation errors
        guard errors.phoneError == nil &&
              errors.passwordError == nil &&
              errors.countryCodeError == nil else {
            return
        }

        // Proceed with API call
        loginApi()
    }
    
    // MARK: - Networking
    @MainActor
    private func loginApi() {
        Task {
            showIndicator()
            let countryCodeKey = PhoneTextView.getCountryCodeOrDefault(countryCode)
            let endPoint = AuthEndpoint.login(phone: phoneNumber, countryCode: countryCodeKey, password: password)

            do {
                let response = try await requestFullResponse(endPoint)
                guard response.data != nil else { return }

                    switch response.key {
                    case .needActive:
                        let code = PhoneTextView.getCountryCodeOrDefault(self.countryCode)
                        self.loginEvent.send(.needsActivation(countryCode: code, phone: self.phoneNumber))
                    case .success:
                        UserDefaults.accessToken = response.data?.token
                        UserDefaults.user = response.data
                        UserDefaults.isFirstTime = false
                        UserDefaults.isLogin = true
                        UserDefaults.isVisitor = false
                        showSuccess("Login successful".localized)

                        // Trigger navigation to home
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.loginEvent.send(.success)
                        }
                    default:
                        break
                    }

            } catch {
                // Check if it's a serialization error
                let errorMessage = error.localizedDescription
                if errorMessage.contains("serialized") ||
                   errorMessage.contains("zero length") ||
                   errorMessage.contains("nil or zero") {
                    showError("server_error_unable_to_process".localized)
                } else {
                    showError(error.localizedDescription)
                }
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
