//
//  MainCategoryDetailsViewModel.swift
//  RentNow
//
//  Created by Claude Code
//

import Foundation
import Combine

@MainActor
final class MainCategoryDetailsViewModel: BaseViewModel {

    @Published var categoryId: Int
    @Published var categoryName: String
    @Published var searchText: String = ""
    @Published var advertisements: [Advertisement] = []
    @Published var subCategories: [SubCategory] = []
    @Published var selectedSubCategoryId: Int?
    @Published var filterParams: FilterParams?
    private var currentFetchTask: Task<Void, Never>?

    init(categoryId: Int, categoryName: String) {
        self.categoryId = categoryId
        self.categoryName = categoryName
    }

    var hasActiveFilters: Bool {
        filterParams?.hasActiveFilters ?? false
    }

    var filteredAdvertisements: [Advertisement] {
        guard !searchText.isEmpty else {
            return advertisements
        }
        return advertisements.filter { ad in
            ad.carName.localizedCaseInsensitiveContains(searchText)
        }
    }

    func fetchSearchResults() async {
        showIndicator()

        // Pass nil when "All" is selected (id: 0), otherwise pass the selected id
        let subCategoryIdParam = (selectedSubCategoryId == 0 || selectedSubCategoryId == nil) ? nil : selectedSubCategoryId

        let endpoint = HomeEndpoint.search(
            mainCategoryId: categoryId,
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

                var allSubCategories = data.subCategories ?? []
                let allSubCategory = SubCategory(
                    id: 0,
                    name: "all_subcategories".localized,
                    imageUrl: "AllCars",
                    mainCategoryId: categoryId,
                    mainCategoryName: categoryName
                )
                allSubCategories.insert(allSubCategory, at: 0)
                self.subCategories = allSubCategories
            }
        } catch {
            if error is CancellationError { return }
            showError(error.localizedDescription)
        }

        hideIndicator()
    }

    func applyFilters(_ params: FilterParams) {
        self.filterParams = params.hasActiveFilters ? params : nil
        currentFetchTask?.cancel()
        currentFetchTask = Task { await fetchSearchResults() }
    }

    func clearFilters() {
        self.filterParams = nil
        currentFetchTask?.cancel()
        currentFetchTask = Task { await fetchSearchResults() }
    }

    func selectSubCategory(_ id: Int) {
        let newId: Int? = id
        guard selectedSubCategoryId != newId else { return }
        selectedSubCategoryId = id
        currentFetchTask?.cancel()
        currentFetchTask = Task { await fetchSearchResults() }
    }
}
