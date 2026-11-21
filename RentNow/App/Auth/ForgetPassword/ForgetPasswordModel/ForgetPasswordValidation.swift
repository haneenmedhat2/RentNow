//
//  ForgetPasswordValidation.swift
//  Holool
//
//  Created by Elshamy on 21/12/2025.
//

import Foundation

// MARK: - Forget Password Validation Logic
struct ForgetPasswordValidation {

    // MARK: - Validation Methods

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

    // MARK: - Validate All

    static func validateForgetPasswordForm(
        phone: String?,
        countryCode: Country?
    ) -> (phoneError: String?, countryCodeError: String?) {
        let phoneError = validatePhone(phone)
        // No error for country code since we always have default "+966"
        return (phoneError, nil)
    }
}
