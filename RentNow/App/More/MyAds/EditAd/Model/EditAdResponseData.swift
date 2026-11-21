//
//  EditAdResponseData.swift
//  RentNow
//

import Foundation

struct EditAdResponseData: Codable {
    let id: Int?
    let description: String?
    let pricePerDay: Double?
    let insuranceValue: Double?
    let minKilometersUsage: Double?
    let maxKilometersUsage: Double?
    let extraKilometerPrice: Double?
    let isDeliveryToRenterLocationEnabled: Bool?
    let imageUrls: [String]?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.pricePerDay = try container.decodeIfPresent(Double.self, forKey: .pricePerDay) ?? 0.0
        self.insuranceValue = try container.decodeIfPresent(Double.self, forKey: .insuranceValue) ?? 0.0
        self.minKilometersUsage = try container.decodeIfPresent(Double.self, forKey: .minKilometersUsage)
        self.maxKilometersUsage = try container.decodeIfPresent(Double.self, forKey: .maxKilometersUsage)
        self.extraKilometerPrice = try container.decodeIfPresent(Double.self, forKey: .extraKilometerPrice)
        self.isDeliveryToRenterLocationEnabled = try container.decodeIfPresent(Bool.self, forKey: .isDeliveryToRenterLocationEnabled)
        self.imageUrls = try container.decodeIfPresent([String].self, forKey: .imageUrls) ?? []
    }
}
