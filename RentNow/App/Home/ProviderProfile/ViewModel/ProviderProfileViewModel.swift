//
//  ProviderProfileViewModel.swift
//  RentNow
//

import Foundation
import Combine

@MainActor
final class ProviderProfileViewModel: BaseViewModel {

    let providerId: String
    @Published var providerName: String
    @Published var providerImage: String
    @Published var advertisements: [Advertisement] = []

    init(providerId: String, providerName: String, providerImage: String) {
        self.providerId = providerId
        self.providerName = providerName
        self.providerImage = providerImage
        super.init()
    }

    func fetchProviderAds() async {
        showIndicator()
        let endpoint = HomeEndpoint.getOwnerAdvertisements(providerId: providerId)
        do {
            let response = try await request(endpoint)
            if let data = response {
                self.providerName = data.name ?? self.providerName
                self.providerImage = data.imageUrl ?? self.providerImage
                self.advertisements = data.advertisements ?? []
            }
        } catch {
            showError(error.localizedDescription)
        }
        hideIndicator()
    }
}
