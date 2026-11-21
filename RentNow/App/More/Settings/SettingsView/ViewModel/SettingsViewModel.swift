//
//  SettingsViewModel.swift
//  RentNow
//

import Foundation
import Combine

@MainActor
final class SettingsViewModel: BaseViewModel {

    @Published var notificationsEnabled: Bool = UserDefaults.user?.allowNotify ?? true

    func toggleNotification() {
        Task {
            showIndicator()
            let endpoint = MoreEndpoint.toggleNotification(isEnabled: notificationsEnabled)
            do {
                let response = try await requestFullResponse(endpoint)

                UserDefaults.user?.allowNotify = notificationsEnabled
                showSuccess(response.message)


            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }

    func deleteAccount() {
        Task {
            showIndicator()
            let endpoint = MoreEndpoint.removeAccount()
            do {
                let response = try await requestFullResponse(endpoint)
                showSuccess(response.message)
                try? await Task.sleep(nanoseconds: 1_500_000_000)
                SessionManager.shared.handleSessionExpired()
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }
}
