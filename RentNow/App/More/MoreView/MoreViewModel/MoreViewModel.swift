//
//  MoreViewModel.swift
//  RentNow
//
//  Created by Elshamy on 11/02/2026.
//

import Foundation
import Combine

@MainActor
class MoreViewModel: BaseViewModel {

    // MARK: - Published Properties
    @Published var userName: String = ""
    @Published var userImage: String = ""
    @Published var packageName: String = ""

    // MARK: - Init
    override init(responseHandler: ResponseHandler = DefaultResponseHandler()) {
        super.init(responseHandler: responseHandler)
        loadUserData()
    }

    // MARK: - Data Loading
    func loadUserData() {
        if let user = UserDefaults.user {
            userName = user.fullName ?? ""
            userImage = user.profilePicture ?? ""
            packageName = user.packageName ?? ""
        }
    }

    // MARK: - Logout
    func performLogout() {
        Task {
            showIndicator()
            let endpoint = MoreEndpoint.logout()
            do {
                let _ = try await request(endpoint)
            } catch {
                // Logout regardless of API result
            }
            hideIndicator()
            SessionManager.shared.handleSessionExpired()
        }
    }
}
