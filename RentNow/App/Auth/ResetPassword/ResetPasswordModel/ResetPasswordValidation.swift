//
//  ResetPasswordValidation.swift
//  Holool
//
//  Created by Elshamy on 21/12/2025.
//

import Foundation

// MARK: - Reset Password Validation Logic
struct ResetPasswordValidation {

    // MARK: - Validation Methods

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
            return "Password fields are required".localized
        }

        do {
            _ = try GeneralValidationService.validate(newPassword: password, confirmPassword: confirmPassword)
            return nil
        } catch {
            return error.localizedDescription
        }
    }

    // MARK: - Validate All

    static func validateResetPasswordForm(
        password: String?,
        confirmPassword: String?
    ) -> (
        passwordError: String?,
        confirmPasswordError: String?
    ) {
        var passwordError = validatePassword(password)
        var confirmPasswordError = validateConfirmPassword(confirmPassword)
        let matchPasswordError = validateMatchPassword(password, confirmPassword: confirmPassword)

        // If passwords don't match, show error in both password fields
        if let matchError = matchPasswordError {
            if passwordError == nil {
                passwordError = matchError
            }
            if confirmPasswordError == nil {
                confirmPasswordError = matchError
            }
        }

        return (passwordError, confirmPasswordError)
    }
}
