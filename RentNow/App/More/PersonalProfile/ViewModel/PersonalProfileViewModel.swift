//
//  PersonalProfileViewModel.swift
//  RentNow
//

import Foundation
import Combine

@MainActor
class PersonalProfileViewModel: BaseViewModel {

    // MARK: - Published Properties
    @Published var profile: ProfileInfoData?

    // MARK: - Fetch Profile
    func fetchProfile() {
        Task {
            showIndicator()
            let endpoint = MoreEndpoint.getProfileInfo()
            do {
                let data = try await request(endpoint)
                self.profile = data
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }
}
