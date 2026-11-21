//
//  MyRatingsViewModel.swift
//  RentNow
//

import Foundation
import Combine

@MainActor
class MyRatingsViewModel: BaseViewModel {

    // MARK: - Published Properties
    @Published var ratings: [MyRateItem] = []

    // MARK: - Computed Properties
    var isEmpty: Bool {
        ratings.isEmpty && !isLoading
    }

    // MARK: - API Calls
    func fetchRatings() async {
        showIndicator()
        let endpoint = MoreEndpoint.getMyRates()
        do {
            let response = try await request(endpoint)
            ratings = response ?? []
        } catch {
            showError(error.localizedDescription)
        }
        hideIndicator()
    }
}
