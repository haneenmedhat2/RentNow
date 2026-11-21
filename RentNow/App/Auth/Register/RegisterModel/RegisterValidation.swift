//
//  RegisterValidation.swift
//  Holool
//
//  Created by Elshamy on 21/12/2025.
//

import Foundation

// MARK: - Register Validation Logic
struct RegisterValidation {

    // MARK: - Validation Methods

    static func validateName(_ name: String?) -> String? {
        do {
            _ = try GeneralValidationService.validate(name: name)
            return nil
        } catch {
            return error.localizedDescription
        }
    }

    static func validatePhone(_ phone: String?) -> String? {
        do {
            _ = try GeneralValidationService.validate(phone: phone)
            return nil
        } catch {
            return error.localizedDescription
        }
    }

    static func validateCountryCode(_ countryCode: String?) -> String? {
        do {
            _ = try GeneralValidationService.validate(countryCode: countryCode)
            return nil
        } catch {
            return error.localizedDescription
        }
    }

    static func validateCity(_ city: String?) -> String? {
        do {
            _ = try GeneralValidationService.validate(city: city)
            return nil
        } catch {
            return error.localizedDescription
        }
    }

    static func validatePassword(_ password: String?) -> String? {
        do {
            _ = try GeneralValidationService.validate(password: password)
            return nil
        } catch {
            return error.localizedDescription
        }
    }

    static func validateConfirmPassword(_ confirmPassword: String?) -> String? {
        do {
            _ = try GeneralValidationService.validate(confirmPassword: confirmPassword)
            return nil
        } catch {
            return error.localizedDescription
        }
    }

    static func validateMatchPassword(_ password: String?, confirmPassword: String?) -> String? {
        guard let password = password, let confirmPassword = confirmPassword else {
            return nil
        }

        do {
            _ = try GeneralValidationService.validate(newPassword: password, confirmPassword: confirmPassword)
            return nil
        } catch {
            return error.localizedDescription
        }
    }

    static func validateAgree(_ isAgree: Bool) -> String? {
        do {
            try GeneralValidationService.validate(termsAgreed: isAgree)
            return nil
        } catch {
            return error.localizedDescription
        }
    }

    // MARK: - National ID Validation
    static func validateNationalId(_ nationalId: String?) -> String? {
        guard let id = nationalId, !id.isEmpty else {
            return "National ID is required".localized
        }
        guard id.count == 10 else {
            return "National ID must be 10 digits".localized
        }
        guard id.first == "1" || id.first == "2" else {
            return "National ID must start with 1 or 2".localized
        }
        guard id.allSatisfy({ $0.isNumber }) else {
            return "National ID must contain only numbers".localized
        }
        return nil
    }

    // MARK: - Country Validation
    static func validateCountry(_ country: Country?) -> String? {
        guard country?.id != nil else {
            return "Please select country".localized
        }
        return nil
    }

    // MARK: - Validate All

    static func validateRegisterForm(
        name: String?,
        phone: String?,
        nationalId: String?,
        countryCode: Country?,
        country: Country?,
        city: City?,
        password: String?,
        confirmPassword: String?,
        isAgree: Bool
    ) -> (
        nameError: String?,
        phoneError: String?,
        nationalIdError: String?,
        countryCodeError: String?,
        countryError: String?,
        cityError: String?,
        passwordError: String?,
        confirmPasswordError: String?,
        agreeError: String?
    ) {
        let nameError = validateName(name)
        let phoneError = validatePhone(phone)
        let nationalIdError = validateNationalId(nationalId)
        // No error for country code since we always have default "+966"
        let countryCodeError: String? = nil
        let countryError = validateCountry(country)
        let cityError = validateCity(city?.name)
        var passwordError = validatePassword(password)
        var confirmPasswordError = validateConfirmPassword(confirmPassword)
        let matchPasswordError = validateMatchPassword(password, confirmPassword: confirmPassword)
        let agreeError = validateAgree(isAgree)

        // If passwords don't match, show error in both password fields
        if let matchError = matchPasswordError {
            if passwordError == nil {
                passwordError = matchError
            }
            if confirmPasswordError == nil {
                confirmPasswordError = matchError
            }
        }

        return (
            nameError,
            phoneError,
            nationalIdError,
            countryCodeError,
            countryError,
            cityError,
            passwordError,
            confirmPasswordError,
            agreeError
        )
    }
}
