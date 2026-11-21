//
//  LoginValidation.swift
//  Holool
//
//  Created by Elshamy on 21/12/2025.
//

import Foundation

// MARK: - Login Validation Logic
struct LoginValidation {

    // MARK: - Validation Methods

    static func validatePhone(_ phone: String?) -> String? {
        do {
            _ = try GeneralValidationService.validate(phone: phone)
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

    static func validateCountryCode(_ countryCode: String?) -> String? {
        do {
            _ = try GeneralValidationService.validate(countryCode: countryCode)
            return nil
        } catch {
            return error.localizedDescription
        }
    }

    // MARK: - Validate All

    static func validateLoginForm(
        phone: String?,
        password: String?,
        countryCode: Country?
    ) -> (phoneError: String?, passwordError: String?, countryCodeError: String?) {
        let phoneError = validatePhone(phone)
        let passwordError = validatePassword(password)
        // Apply default "+966" if no country code is selected
        // No error should be shown when using default
        let codeToValidate = countryCode?.key ?? "+966"
        let countryCodeError = validateCountryCode(codeToValidate)

        return (phoneError, passwordError, nil) // Always return nil for country code error since we have default
    }
}
