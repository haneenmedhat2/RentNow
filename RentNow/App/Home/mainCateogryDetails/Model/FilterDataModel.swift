//
//  FilterDataModel.swift
//  RentNow
//
//  Created by Claude Code
//

import Foundation

// MARK: - Filter Data Response
struct FilterDataResponse: Codable {
    let minPrice: Double?
    let maxPrice: Double?
    let additionalFeatures: [AdditionalFeature]?
    let cities: [FilterCity]?
    let carModels: [CarModel]?
    let fuelTypes: [FuelType]?
    let subCategories: [SubCategory]?
}

// MARK: - Car Model
struct CarModel: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
}

// MARK: - Fuel Type
struct FuelType: Codable, Identifiable, Hashable {
    let value: Int
    let name: String

    var id: Int { value }
}

// MARK: - Filter City
struct FilterCity: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let latitude: Double?
    let longitude: Double?
    let countryId: Int?
    let countryName: String?
}

// MARK: - Additional Feature
struct AdditionalFeature: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
}

// MARK: - Filter Params (for applying filters)
struct FilterParams: Equatable {
    var carTypeIds: [Int] = []
    var fuelTypes: [Int] = []
    var cityIds: [Int] = []
    var additionalFeatureIds: [Int] = []
    var minPrice: Double?
    var maxPrice: Double?
    var subCategoryId: Int?

    var hasActiveFilters: Bool {
        !carTypeIds.isEmpty ||
        !fuelTypes.isEmpty ||
        !cityIds.isEmpty ||
        !additionalFeatureIds.isEmpty ||
        minPrice != nil ||
        maxPrice != nil ||
        subCategoryId != nil
    }

    var selectedCount: Int {
        carTypeIds.count + fuelTypes.count + cityIds.count + additionalFeatureIds.count + (subCategoryId != nil ? 1 : 0)
    }
}
