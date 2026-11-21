//
//  CreateAdResponse.swift
//  RentNow
//

import Foundation

struct CreateAdResponse: Codable {
    let id: Int?
    let description: String?
    let pricePerDay: Double?
    let fuelType: String?
    let latitude: Double?
    let longitude: Double?
    let reviewStatus: String?
    let insuranceValue: Double?
    let carName: String?
    let mainCategoryName: String?
    let subCategoryName: String?
    let carModelName: String?
    let carTypeName: String?
    let cityName: String?
    let imageUrls: [String]?
    let isDeliveryToRenterLocationEnabled: Bool?
    let minKilometersUsage: Int?
    let maxKilometersUsage: Int?
    let extraKilometerPrice: Double?
    let creationDate: String?
    let message: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.pricePerDay = try container.decodeIfPresent(Double.self, forKey: .pricePerDay) ?? 0.0
        self.fuelType = try container.decodeIfPresent(String.self, forKey: .fuelType) ?? ""
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0.0
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0.0
        self.reviewStatus = try container.decodeIfPresent(String.self, forKey: .reviewStatus) ?? ""
        self.insuranceValue = try container.decodeIfPresent(Double.self, forKey: .insuranceValue) ?? 0.0
        self.carName = try container.decodeIfPresent(String.self, forKey: .carName) ?? ""
        self.mainCategoryName = try container.decodeIfPresent(String.self, forKey: .mainCategoryName) ?? ""
        self.subCategoryName = try container.decodeIfPresent(String.self, forKey: .subCategoryName) ?? ""
        self.carModelName = try container.decodeIfPresent(String.self, forKey: .carModelName) ?? ""
        self.carTypeName = try container.decodeIfPresent(String.self, forKey: .carTypeName) ?? ""
        self.cityName = try container.decodeIfPresent(String.self, forKey: .cityName) ?? ""
        self.imageUrls = try container.decodeIfPresent([String].self, forKey: .imageUrls) ?? []
        self.isDeliveryToRenterLocationEnabled = try container.decodeIfPresent(Bool.self, forKey: .isDeliveryToRenterLocationEnabled)
        self.minKilometersUsage = try container.decodeIfPresent(Int.self, forKey: .minKilometersUsage)
        self.maxKilometersUsage = try container.decodeIfPresent(Int.self, forKey: .maxKilometersUsage)
        self.extraKilometerPrice = try container.decodeIfPresent(Double.self, forKey: .extraKilometerPrice) ?? 0.0
        self.creationDate = try container.decodeIfPresent(String.self, forKey: .creationDate) ?? ""
        self.message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
    }
}
