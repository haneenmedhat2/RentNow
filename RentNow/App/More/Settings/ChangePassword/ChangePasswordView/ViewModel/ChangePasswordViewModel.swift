//
//  ChangePasswordViewModel.swift
//  RentNow
//
//  Created by Elshamy on 12/02/2026.
//

import SwiftUI
import Combine

final class ChangePasswordViewModel: BaseViewModel {

    @Published var currentPassword: String = ""
    @Published var currentPasswordError: String? = nil
    @Published var hasEditedCurrentPassword: Bool = false

    @Published var newPassword: String = ""
    @Published var newPasswordError: String? = nil
    @Published var hasEditedNewPassword: Bool = false

    @Published var confirmPassword: String = ""
    @Published var confirmPasswordError: String? = nil
    @Published var hasEditedConfirmPassword: Bool = false

    @Published var showSuccess: Bool = false

    // MARK: - Validation

    private func validate() -> Bool {
        var isValid = true

        // Current password
        if currentPassword.isEmpty {
            currentPasswordError = "Current password is required".localized
            isValid = false
        } else if currentPassword.count < 6 {
            currentPasswordError = "Password must be at least 6 characters".localized
            isValid = false
        } else {
            currentPasswordError = nil
        }

        // New password
        if newPassword.isEmpty {
            newPasswordError = "New password is required".localized
            isValid = false
        } else if newPassword.count < 6 {
            newPasswordError = "Password must be at least 6 characters".localized
            isValid = false
        } else {
            newPasswordError = nil
        }

        // Confirm password
        if confirmPassword.isEmpty {
            confirmPasswordError = "Password confirmation is required".localized
            isValid = false
        } else if confirmPassword != newPassword {
            confirmPasswordError = "Passwords do not match".localized
            isValid = false
        } else {
            confirmPasswordError = nil
        }

        return isValid
    }

    // MARK: - API: Change Password

    func changePassword() {
        guard validate() else { return }
        Task {
            showIndicator()
            let phoneNumber = UserDefaults.user?.phoneNumber ?? ""
            let endpoint = MoreEndpoint.changePassword(
                phoneNumber: phoneNumber,
                oldPassword: currentPassword,
                newPassword: newPassword
            )
            do {
                let _ = try await request(endpoint)
                await MainActor.run {
                    showSuccess = true
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
