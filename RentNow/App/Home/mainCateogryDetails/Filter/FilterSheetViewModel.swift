//
//  FilterSheetViewModel.swift
//  RentNow
//
//  Created by Claude Code
//

import Foundation
import Combine

@MainActor
final class FilterSheetViewModel: BaseViewModel {

    // MARK: - Input Properties
    let mainCategoryId: Int?
    let searchQuery: String?

    // MARK: - Published Filter Data
    @Published var carModels: [CarModel] = []
    @Published var fuelTypes: [FuelType] = []
    @Published var cities: [FilterCity] = []
    @Published var additionalFeatures: [AdditionalFeature] = []
    @Published var subCategories: [SubCategory] = []
    @Published var minPriceLimit: Double = 0
    @Published var maxPriceLimit: Double = 1000

    // MARK: - Published Selection State
    @Published var selectedCarTypeIds: Set<Int> = []
    @Published var selectedFuelTypes: Set<Int> = []
    @Published var selectedCityIds: Set<Int> = []
    @Published var selectedAdditionalFeatureIds: Set<Int> = []
    @Published var selectedSubCategoryId: Int?
    @Published var selectedMinPrice: Double = 0
    @Published var selectedMaxPrice: Double = 1000
    @Published var isPriceFilterActive: Bool = false

    // MARK: - Initialization
    init(mainCategoryId: Int?, searchQuery: String?, existingParams: FilterParams? = nil) {
        self.mainCategoryId = mainCategoryId
        self.searchQuery = searchQuery
        super.init()

        // Restore existing filter state if provided
        if let params = existingParams {
            selectedCarTypeIds = Set(params.carTypeIds)
            selectedFuelTypes = Set(params.fuelTypes)
            selectedCityIds = Set(params.cityIds)
            selectedAdditionalFeatureIds = Set(params.additionalFeatureIds)
            selectedSubCategoryId = params.subCategoryId
            if let min = params.minPrice {
                selectedMinPrice = min
                isPriceFilterActive = true
            }
            if let max = params.maxPrice {
                selectedMaxPrice = max
                isPriceFilterActive = true
            }
        }
    }

    // MARK: - Computed Properties

    var selectedCount: Int {
        selectedCarTypeIds.count +
        selectedFuelTypes.count +
        selectedCityIds.count +
        selectedAdditionalFeatureIds.count +
        (isPriceFilterActive ? 1 : 0) +
        (selectedSubCategoryId != nil ? 1 : 0)
    }

    var hasActiveFilters: Bool {
        !selectedCarTypeIds.isEmpty ||
        !selectedFuelTypes.isEmpty ||
        !selectedCityIds.isEmpty ||
        !selectedAdditionalFeatureIds.isEmpty ||
        isPriceFilterActive ||
        selectedSubCategoryId != nil
    }

    var filterParams: FilterParams {
        FilterParams(
            carTypeIds: Array(selectedCarTypeIds),
            fuelTypes: Array(selectedFuelTypes),
            cityIds: Array(selectedCityIds),
            additionalFeatureIds: Array(selectedAdditionalFeatureIds),
            minPrice: isPriceFilterActive ? selectedMinPrice : nil,
            maxPrice: isPriceFilterActive ? selectedMaxPrice : nil,
            subCategoryId: selectedSubCategoryId
        )
    }

    // MARK: - API Call

    func fetchFilterData() async {
        showIndicator()

        let endpoint = HomeEndpoint.filterData(
            mainCategoryId: mainCategoryId,
            searchQuery: searchQuery
        )

        do {
            let response = try await request(endpoint)

            if let data = response {
                self.carModels = data.carModels ?? []
                self.fuelTypes = data.fuelTypes ?? []
                self.cities = data.cities ?? []
                self.additionalFeatures = data.additionalFeatures ?? []
                self.subCategories = data.subCategories ?? []

                // Set price limits
                if let min = data.minPrice {
                    self.minPriceLimit = min
                    if !isPriceFilterActive {
                        self.selectedMinPrice = min
                    }
                }
                if let max = data.maxPrice {
                    self.maxPriceLimit = max
                    if !isPriceFilterActive {
                        self.selectedMaxPrice = max
                    }
                }
            }
        } catch {
            showError(error.localizedDescription)
        }

        hideIndicator()
    }

    // MARK: - Selection Methods

    func toggleCarModel(_ id: Int) {
        if selectedCarTypeIds.contains(id) {
            selectedCarTypeIds.remove(id)
        } else {
            selectedCarTypeIds.insert(id)
        }
    }

    func selectAllCarModels() {
        selectedCarTypeIds = Set(carModels.map { $0.id })
    }

    func toggleFuelType(_ value: Int) {
        if selectedFuelTypes.contains(value) {
            selectedFuelTypes.remove(value)
        } else {
            selectedFuelTypes.insert(value)
        }
    }

    func toggleCity(_ id: Int) {
        if selectedCityIds.contains(id) {
            selectedCityIds.remove(id)
        } else {
            selectedCityIds.insert(id)
        }
    }

    func selectAllCities() {
        selectedCityIds = Set(cities.map { $0.id })
    }

    func toggleAdditionalFeature(_ id: Int) {
        if selectedAdditionalFeatureIds.contains(id) {
            selectedAdditionalFeatureIds.remove(id)
        } else {
            selectedAdditionalFeatureIds.insert(id)
        }
    }

    func toggleSubCategory(_ id: Int) {
        if selectedSubCategoryId == id {
            selectedSubCategoryId = nil
        } else {
            selectedSubCategoryId = id
        }
    }

    func resetFilters() {
        selectedCarTypeIds.removeAll()
        selectedFuelTypes.removeAll()
        selectedCityIds.removeAll()
        selectedAdditionalFeatureIds.removeAll()
        selectedSubCategoryId = nil
        selectedMinPrice = minPriceLimit
        selectedMaxPrice = maxPriceLimit
        isPriceFilterActive = false
    }
}
