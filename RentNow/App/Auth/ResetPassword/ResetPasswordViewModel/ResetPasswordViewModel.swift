//
//  LoginViewModel.swift
//  Holool
//
//  Created by Elshamy on 03/11/2025.
//

import Foundation
import Combine

class ResetPasswordViewModel: BaseViewModel {

    // Active code, phone number, and country code (passed from previous screen)
    var activeCode: String
    var phoneNumber: String
    var countryCode: String

    // MARK: - Inputs
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    // MARK: - Errors
    @Published var passwordError: String? = nil
    @Published var confirmPasswordError: String? = nil

    // MARK: - Success Overlay
    @Published var showSuccessOverlay = false

    init(activeCode: String,
         phoneNumber: String,
         countryCode: String = "966",
         responseHandler: any ResponseHandler = DefaultResponseHandler()) {
        self.activeCode = activeCode
        self.phoneNumber = phoneNumber
        self.countryCode = countryCode
        super.init(responseHandler: responseHandler)
    }
 
    
    
    @MainActor func callApi() {
        // Validate all fields using isolated validation logic
        let errors = ResetPasswordValidation.validateResetPasswordForm(
            password: password,
            confirmPassword: confirmPassword
        )

        // Update error states
        passwordError = errors.passwordError
        confirmPasswordError = errors.confirmPasswordError

        // If any validation failed, stop here
        // NO Toast for validation errors
        guard errors.passwordError == nil &&
              errors.confirmPasswordError == nil else {
            return
        }

        // Proceed with API call
        resetPasswordApi()
    }
    
    // MARK: - Networking
    @MainActor
    private func resetPasswordApi() {
        Task {
            showIndicator()
            let endPoint = AuthEndpoint.resetPassword(password: password, confirmPassword: confirmPassword, countryCode: countryCode, phone: phoneNumber)

            do {
                _ = try await requestFullResponse(endPoint)
                showSuccessOverlay = true
            } catch {

                    showError(error.localizedDescription)


            }
            hideIndicator()
        }
    }
    
  
}

