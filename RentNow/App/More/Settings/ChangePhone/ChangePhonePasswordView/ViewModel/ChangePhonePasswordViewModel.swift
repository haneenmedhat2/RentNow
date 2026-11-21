//
//  ChangePhonePasswordViewModel.swift
//  RentNow
//
//  Created by Elshamy on 12/02/2026.
//

import SwiftUI
import Combine

final class ChangePhonePasswordViewModel: BaseViewModel {

    @Published var password: String = ""
    @Published var passwordError: String? = nil
    @Published var hasEditedPassword: Bool = false

    // MARK: - Validation

    private func validatePassword() -> Bool {
        if password.isEmpty {
            passwordError = "Current password is required".localized
            return false
        }
        if password.count < 6 {
            passwordError = "Password must be at least 6 characters".localized
            return false
        }
        passwordError = nil
        return true
    }

    // MARK: - API: Validate Password

    func validatePasswordApi() {
        guard validatePassword() else { return }
        Task {
            showIndicator()
            let endpoint = MoreEndpoint.validatePassword(password: password)
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
