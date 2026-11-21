//
//  MyAdsViewModel.swift
//  RentNow
//
//  Created by Claude Code
//

import Foundation
import Combine
@MainActor
class MyAdsViewModel: BaseViewModel {

    // MARK: - Published Properties
    @Published var ads: [MyAdItem] = []
    @Published var selectedFilter: MyAdFilterType = .underReview
    private var currentFetchTask: Task<Void, Never>?

    // MARK: - Computed Properties
    var isEmpty: Bool {
        ads.isEmpty && !isLoading
    }

    // MARK: - API Calls
    func fetchAds(showLoading: Bool = true) async {
        if showLoading { showIndicator() }
        defer { if showLoading { hideIndicator() } }
        let endpoint = MoreEndpoint.getMyAds(status: selectedFilter.rawValue)
        do {
            let response = try await request(endpoint)
            ads = response ?? []
        } catch {
            if error is CancellationError { return }
            showError(error.localizedDescription)
        }
    }

    // MARK: - Actions
    func selectFilter(_ filter: MyAdFilterType) {
        guard filter != selectedFilter else { return }
        selectedFilter = filter
        ads = []
        currentFetchTask?.cancel()
        currentFetchTask = Task { await fetchAds() }
    }
}
