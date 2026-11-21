//
//  RegisterViewModel.swift
//  Holool
//
//  Created by Elshamy on 09/11/2025.
//


import Foundation
import Combine

class RegisterViewModel: BaseViewModel {

    @Published var countriesArray: [Country] = []
    @Published var citiesArray: [City] = []

    // MARK: - Inputs
    @Published var name: String = ""
    @Published var phoneNumber: String = ""
    @Published var nationalId: String = ""
    @Published var countryCode: Country? = nil
    @Published var country: Country? = nil
    @Published var city: City? = nil
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var isAgree: Bool = false
    @Published var profileImage: Data? = nil

    // MARK: - Errors
    @Published var nameError: String? = nil
    @Published var phoneError: String? = nil
    @Published var nationalIdError: String? = nil
    @Published var countryCodeError: String? = nil
    @Published var countryError: String? = nil
    @Published var cityError: String? = nil
    @Published var passwordError: String? = nil
    @Published var confirmPasswordError: String? = nil
    @Published var agreeError: String? = nil

    override init(responseHandler: any ResponseHandler = DefaultResponseHandler()) {
        super.init(responseHandler: responseHandler)
        getCountries()
    }

    // MARK: - Country Selection Handler
    func onCountrySelected(_ newCountry: Country?) {
        // Clear city when country changes
        city = nil
        citiesArray = []
        cityError = nil

        // Fetch cities for selected country
        if let countryId = newCountry?.id {
            getCities(countryId: countryId)
        }
    }

    @MainActor func callApi() {
        // Validate all fields using isolated validation logic
        let errors = RegisterValidation.validateRegisterForm(
            name: name,
            phone: phoneNumber,
            nationalId: nationalId,
            countryCode: countryCode,
            country: country,
            city: city,
            password: password,
            confirmPassword: confirmPassword,
            isAgree: isAgree
        )

        // Update error states
        nameError = errors.nameError
        phoneError = errors.phoneError
        nationalIdError = errors.nationalIdError
        countryCodeError = errors.countryCodeError
        countryError = errors.countryError
        cityError = errors.cityError
        passwordError = errors.passwordError
        confirmPasswordError = errors.confirmPasswordError
        agreeError = errors.agreeError

        // If any validation failed, stop here
        // NO Toast for validation errors
        guard errors.nameError == nil &&
              errors.phoneError == nil &&
              errors.nationalIdError == nil &&
              errors.countryCodeError == nil &&
              errors.countryError == nil &&
              errors.cityError == nil &&
              errors.passwordError == nil &&
              errors.confirmPasswordError == nil &&
              errors.agreeError == nil else {
            return
        }

        // Proceed with API call
        registerApi()
    }
}


// MARK: - API Methods
extension RegisterViewModel {
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

    func getCities(countryId: Int) {
        Task {
            showIndicator()
            let endPoint = AuthEndpoint.getCities(countryId: countryId)

            do {
                let response = try await requestFullResponse(endPoint)
                guard let data = response.data else { return }
                await MainActor.run {
                    self.citiesArray = data
                }
            } catch {
                await MainActor.run {
                    showError(error.localizedDescription)
                }
            }
            hideIndicator()
        }
    }

    @MainActor
    func registerApi() {
        Task {
            showIndicator()
            guard let cityId = city?.id,
                  let countryId = country?.id else { return }

            // Format phone number for API (ensure 05XXXXXXXX format)
            let countryCodeKey = PhoneTextView.getCountryCodeOrDefault(countryCode)
            let formattedPhone = PhoneTextView.formatPhoneForApi(phoneNumber, countryCode: countryCodeKey)

            let endPoint = AuthEndpoint.register(
                userName: name,
                phone: formattedPhone,
                countryCode: countryCodeKey,
                nationalId: nationalId,
                countryId: countryId,
                cityId: cityId,
                password: password,
                confirmPassword: confirmPassword,
                imageData: profileImage
            )

            do {
                let response = try await requestFullResponse(endPoint)
                handleRegisterResponse(response)
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }

    // MARK: - Response Handling
    private func handleRegisterResponse(_ response: BaseResponse<Bool>) {
        switch response.messageKey {
        case "RegistrationSuccessfulAndVerified":
            showSuccess(response.message)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.successMessage = response.message
            }
        case "NafazVerificationFailed":
            showError(response.message)
        default:
            showSuccess(response.message)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.successMessage = response.message
            }
        }
    }

}
