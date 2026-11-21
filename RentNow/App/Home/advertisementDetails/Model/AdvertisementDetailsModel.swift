//
//  AdvertisementDetailsModel.swift
//  RentNow
//

import Foundation

struct AdvertisementDetailsData: Codable {
    let id: Int?
    let carName: String?
    let images: [String]?
    let mainCategoryName: String?
    let subCategoryName: String?
    let cityName: String?
    let latitude: Double?
    let longitude: Double?
    let geoAddress: String?
    let fuelType: String?
    let description: String?
    let safetyInstructions: String?
    let pricePerDay: Double?
    let isAvailableForOrdering: Bool?
    let canOrder: Bool?
    let averageRating: Double?
    let provider: AdvertisementProvider?
    let latestRates: [AdvertisementRate]?
    let relatedAds: [Advertisement]?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.carName = try container.decodeIfPresent(String.self, forKey: .carName) ?? ""
        self.images = try container.decodeIfPresent([String].self, forKey: .images) ?? []
        self.mainCategoryName = try container.decodeIfPresent(String.self, forKey: .mainCategoryName) ?? ""
        self.subCategoryName = try container.decodeIfPresent(String.self, forKey: .subCategoryName) ?? ""
        self.cityName = try container.decodeIfPresent(String.self, forKey: .cityName) ?? ""
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        self.geoAddress = try container.decodeIfPresent(String.self, forKey: .geoAddress) ?? ""
        self.fuelType = try container.decodeIfPresent(String.self, forKey: .fuelType)
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.safetyInstructions = try container.decodeIfPresent(String.self, forKey: .safetyInstructions)
        self.pricePerDay = try container.decodeIfPresent(Double.self, forKey: .pricePerDay)
        self.isAvailableForOrdering = try container.decodeIfPresent(Bool.self, forKey: .isAvailableForOrdering)
        self.canOrder = try container.decodeIfPresent(Bool.self, forKey: .canOrder)
        self.averageRating = try container.decodeIfPresent(Double.self, forKey: .averageRating) ?? 0.0
        self.provider = try container.decodeIfPresent(AdvertisementProvider.self, forKey: .provider)
        self.latestRates = try container.decodeIfPresent([AdvertisementRate].self, forKey: .latestRates) ?? []
        self.relatedAds = try container.decodeIfPresent([Advertisement].self, forKey: .relatedAds) ?? []
    }
}

struct AdvertisementProvider: Codable {
    let providerId: String?
    let providerName: String?
    let providerImage: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.providerId = try container.decodeIfPresent(String.self, forKey: .providerId) ?? ""
        self.providerName = try container.decodeIfPresent(String.self, forKey: .providerName) ?? ""
        self.providerImage = try container.decodeIfPresent(String.self, forKey: .providerImage) ?? ""
    }
}

struct AdvertisementRate: Codable, Identifiable {
    var id: Int?
    let userName: String?
    let userImage: String?
    let rating: Double?
    let comment: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case userName = "raterName"
        case userImage = "raterImage"
        case rating
        case comment
        case createdAt = "ratingDate"
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = nil
        self.userName = try container.decodeIfPresent(String.self, forKey: .userName) ?? ""
        self.userImage = try container.decodeIfPresent(String.self, forKey: .userImage) ?? ""
        self.rating = try container.decodeIfPresent(Double.self, forKey: .rating) ?? 0.0
        self.comment = try container.decodeIfPresent(String.self, forKey: .comment) ?? ""
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt)
    }
}
