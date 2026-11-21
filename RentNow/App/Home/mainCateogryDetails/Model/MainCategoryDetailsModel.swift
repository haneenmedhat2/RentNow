//
//  MainCategoryDetailsModel.swift
//  RentNow
//
//  Created by Claude Code
//

import Foundation

struct MainCategoryDetailsData: Codable {
    let advertisments: [Advertisement]?
    let subCategories: [SubCategory]?
}

struct Advertisement: Codable, Identifiable {
    let id: Int
    let carName: String
    let averageRating: Double?
    let cityName: String
    let geoAddress: String
    let pricePerDay: Double
    let mainImageUrl: String

    enum CodingKeys: String, CodingKey {
        case id, carName, averageRating, cityName, geoAddress, location, pricePerDay, mainImageUrl
    }

    init(id: Int, carName: String, averageRating: Double?, cityName: String, geoAddress: String, pricePerDay: Double, mainImageUrl: String) {
        self.id = id
        self.carName = carName
        self.averageRating = averageRating
        self.cityName = cityName
        self.geoAddress = geoAddress
        self.pricePerDay = pricePerDay
        self.mainImageUrl = mainImageUrl
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.carName = try container.decodeIfPresent(String.self, forKey: .carName) ?? ""
        self.averageRating = try container.decodeIfPresent(Double.self, forKey: .averageRating)
        self.cityName = try container.decodeIfPresent(String.self, forKey: .cityName) ?? ""
        self.pricePerDay = try container.decodeIfPresent(Double.self, forKey: .pricePerDay) ?? 0.0
        self.mainImageUrl = try container.decodeIfPresent(String.self, forKey: .mainImageUrl) ?? ""
        if let geo = try container.decodeIfPresent(String.self, forKey: .geoAddress) {
            self.geoAddress = geo
        } else {
            self.geoAddress = try container.decodeIfPresent(String.self, forKey: .location) ?? ""
        }
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(carName, forKey: .carName)
        try container.encodeIfPresent(averageRating, forKey: .averageRating)
        try container.encode(cityName, forKey: .cityName)
        try container.encode(geoAddress, forKey: .geoAddress)
        try container.encode(pricePerDay, forKey: .pricePerDay)
        try container.encode(mainImageUrl, forKey: .mainImageUrl)
    }
}

struct SubCategory: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let imageUrl: String?
    let mainCategoryId: Int
    let mainCategoryName: String
}

struct SearchFilterParams {
    var carTypeIds: [Int] = []
    var fuelTypes: [Int] = []
    var cityIds: [Int] = []
    var additionalFeatureIds: [Int] = []
    var minPrice: Double? = nil
    var maxPrice: Double? = nil
    var carName: String? = nil
}
