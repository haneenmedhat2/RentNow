//
//  MyAdDetailsModel.swift
//  RentNow
//
//  Created by Claude Code
//

import Foundation

struct AdditionalFeatureItem: Codable {
    let id: Int?
    let name: String?
    let featureCost: Double?
    let isSelected: Bool?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id          = try container.decodeIfPresent(Int.self,    forKey: .id)
        self.name        = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.featureCost = try container.decodeIfPresent(Double.self, forKey: .featureCost) ?? 0.0
        self.isSelected  = try container.decodeIfPresent(Bool.self,   forKey: .isSelected)
    }
}

struct MyAdDetailsData: Codable {
    let id: Int?
    let canEdit: Bool?
    let canDelete: Bool?
    let canBeUnavailable: Bool?
    let images: [String]?
    let mainCategoryName: String?
    let subCategoryName: String?
    let isDeliveryToRenterLocationEnabled: Bool?
    let carName: String?
    let cityName: String?
    let geoAddress: String?
    let latitude: Double?
    let longitude: Double?
    let pricePerDay: Double?
    let insurranceValue: Double?
    let fuelType: String?
    let description: String?
    let safetyInstructions: String?
    let statusText: String?
    let vatPercentage: Double?
    let isAvailableForOrdering: Bool?
    let canOrder: Bool?
    let averageRating: Double?
    let additionalFeatures: [AdditionalFeatureItem]?
    let minKilometersUsage: Double?
    let maxKilometersUsage: Double?
    let extraKilometerPrice: Double?
    let provider: AdvertisementProvider?
    let latestRates: [AdvertisementRate]?
    let rejectionReason: String?
    let relatedAds: [Advertisement]?

    enum CodingKeys: String, CodingKey {
        case id, canEdit, canDelete, canBeUnavailable, images
        case mainCategoryName, subCategoryName
        case isDeliveryToRenterLocationEnabled
        case carName, cityName, geoAddress, latitude, longitude
        case pricePerDay, insurranceValue, fuelType, description, safetyInstructions
        case statusText = "status"
        case vatPercentage, isAvailableForOrdering, canOrder, averageRating
        case additionalFeatures
        case minKilometersUsage, maxKilometersUsage, extraKilometerPrice
        case provider, latestRates, rejectionReason, relatedAds
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.canEdit = try container.decodeIfPresent(Bool.self, forKey: .canEdit)
        self.canDelete = try container.decodeIfPresent(Bool.self, forKey: .canDelete)
        self.canBeUnavailable = try container.decodeIfPresent(Bool.self, forKey: .canBeUnavailable)
        self.images = try container.decodeIfPresent([String].self, forKey: .images) ?? []
        self.mainCategoryName = try container.decodeIfPresent(String.self, forKey: .mainCategoryName) ?? ""
        self.subCategoryName = try container.decodeIfPresent(String.self, forKey: .subCategoryName) ?? ""
        self.isDeliveryToRenterLocationEnabled = try container.decodeIfPresent(Bool.self, forKey: .isDeliveryToRenterLocationEnabled) ?? false
        self.carName = try container.decodeIfPresent(String.self, forKey: .carName) ?? ""
        self.cityName = try container.decodeIfPresent(String.self, forKey: .cityName) ?? ""
        self.geoAddress = try container.decodeIfPresent(String.self, forKey: .geoAddress) ?? ""
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        self.pricePerDay = try container.decodeIfPresent(Double.self, forKey: .pricePerDay) ?? 0.0
        self.insurranceValue = try container.decodeIfPresent(Double.self, forKey: .insurranceValue) ?? 0.0
        self.fuelType = try container.decodeIfPresent(String.self, forKey: .fuelType) ?? ""
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.safetyInstructions = try container.decodeIfPresent(String.self, forKey: .safetyInstructions)
        self.statusText = try container.decodeIfPresent(String.self, forKey: .statusText) ?? ""
        self.vatPercentage = try container.decodeIfPresent(Double.self, forKey: .vatPercentage) ?? 0.0
        self.isAvailableForOrdering = try container.decodeIfPresent(Bool.self, forKey: .isAvailableForOrdering)
        self.canOrder = try container.decodeIfPresent(Bool.self, forKey: .canOrder)
        self.averageRating = try container.decodeIfPresent(Double.self, forKey: .averageRating) ?? 0.0
        self.additionalFeatures = try container.decodeIfPresent([AdditionalFeatureItem].self, forKey: .additionalFeatures) ?? []
        self.minKilometersUsage = try container.decodeIfPresent(Double.self, forKey: .minKilometersUsage) ?? 0.0
        self.maxKilometersUsage = try container.decodeIfPresent(Double.self, forKey: .maxKilometersUsage) ?? 0.0
        self.extraKilometerPrice = try container.decodeIfPresent(Double.self, forKey: .extraKilometerPrice) ?? 0.0
        self.provider = try container.decodeIfPresent(AdvertisementProvider.self, forKey: .provider)
        self.latestRates = try container.decodeIfPresent([AdvertisementRate].self, forKey: .latestRates) ?? []
        self.rejectionReason = try container.decodeIfPresent(String.self, forKey: .rejectionReason) ?? ""
        self.relatedAds = try container.decodeIfPresent([Advertisement].self, forKey: .relatedAds) ?? []
    }
}
