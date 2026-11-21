//
//  SearchViewModel.swift
//  RentNow
//
//  Created by Claude Code
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: BaseViewModel {

    @Published var searchText: String = ""
    @Published var advertisements: [Advertisement] = []
    @Published var filterParams: FilterParams?
    @Published var hasSearched: Bool = false

    private var searchCancellables = Set<AnyCancellable>()

    override init(responseHandler: ResponseHandler = DefaultResponseHandler()) {
        super.init(responseHandler: responseHandler)
        setupDebounce()
    }

    var hasActiveFilters: Bool {
        filterParams?.hasActiveFilters ?? false
    }

    var filteredAdvertisements: [Advertisement] {
        return advertisements
    }

    private func setupDebounce() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] (text: String) in
                guard let self = self else { return }
                if !text.isEmpty {
                    Task {
                        await self.fetchSearchResults()
                    }
                } else {
                    self.advertisements = []
                    self.hasSearched = false
                }
            }
            .store(in: &searchCancellables)
    }

    func fetchSearchResults() async {
        showIndicator()
        hasSearched = true

        let subCategoryIdParam = filterParams?.subCategoryId

        let endpoint = HomeEndpoint.search(
            mainCategoryId: nil,
            subCategoryId: subCategoryIdParam,
            carTypeIds: filterParams?.carTypeIds,
            fuelTypes: filterParams?.fuelTypes,
            cityIds: filterParams?.cityIds,
            additionalFeatureIds: filterParams?.additionalFeatureIds,
            minPrice: filterParams?.minPrice,
            maxPrice: filterParams?.maxPrice,
            carName: searchText.isEmpty ? nil : searchText
        )

        do {
            let response = try await request(endpoint)

            if let data = response {
                self.advertisements = data.advertisments ?? []
            }
        } catch {
            if error is CancellationError { return }
            showError(error.localizedDescription)
        }

        hideIndicator()
    }

    func applyFilters(_ params: FilterParams) {
        if params.hasActiveFilters {
            self.filterParams = params
            Task {
                await fetchSearchResults()
            }
        } else {
            self.filterParams = nil
            self.searchText = ""
            self.advertisements = []
            self.hasSearched = false
        }
    }
}
