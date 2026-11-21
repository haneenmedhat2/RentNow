//
//  AllRatingsViewModel.swift
//  RentNow
//

import Foundation
import Combine

@MainActor
final class AllRatingsViewModel: BaseViewModel {

    let advertisementId: Int
    @Published var ratings: [RateData] = []
    private var currentPage: Int = 1
    private var hasNextPage: Bool = false
    @Published var isLoadingMore: Bool = false

    init(advertisementId: Int) {
        self.advertisementId = advertisementId
    }

    func fetchRatings() async {
        showIndicator()
        currentPage = 1
        let endpoint = AllRatingsEndpoint.getAdRates(advertisementId: advertisementId, pageNumber: currentPage)
        do {
            let data = try await request(endpoint)
            ratings = data?.result ?? []
            hasNextPage = data?.pagination?.hasNextPage ?? false
        } catch {
            showError(error.localizedDescription)
        }
        hideIndicator()
    }

    func loadMoreIfNeeded(currentItem: RateData) {
        guard let lastItem = ratings.last,
              lastItem.name == currentItem.name && lastItem.date == currentItem.date,
              hasNextPage,
              !isLoadingMore else { return }

        isLoadingMore = true
        currentPage += 1
        Task {
            let endpoint = AllRatingsEndpoint.getAdRates(advertisementId: advertisementId, pageNumber: currentPage)
            do {
                let data = try await request(endpoint)
                ratings.append(contentsOf: data?.result ?? [])
                hasNextPage = data?.pagination?.hasNextPage ?? false
            } catch {
                showError(error.localizedDescription)
                currentPage -= 1
            }
            isLoadingMore = false
        }
    }
}
