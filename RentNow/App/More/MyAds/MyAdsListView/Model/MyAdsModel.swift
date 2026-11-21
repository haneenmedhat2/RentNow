//
//  MyAdsModel.swift
//  RentNow
//
//  Created by Claude Code
//

import Foundation

// MARK: - My Ad Filter Type
enum MyAdFilterType: String, CaseIterable {
    case underReview = "UnderReview"
    case approved = "Approved"
    case rejectedWithNotes = "RejectedWithNotes"

    var title: String {
        switch self {
        case .underReview: return "Under Review".localized
        case .approved: return "Current".localized
        case .rejectedWithNotes: return "Rejected".localized
        }
    }
}

// MARK: - My Ad Item
struct MyAdItem: Codable, Identifiable {
    let id: Int?
    let carName: String?
    let averageRating: Double?
    let cityName: String?
    let geoAddress: String?
    let pricePerDay: Double?
    let mainImageUrl: String?
    let statusText: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.carName = try container.decodeIfPresent(String.self, forKey: .carName) ?? ""
        self.averageRating = try container.decodeIfPresent(Double.self, forKey: .averageRating) ?? 0.0
        self.cityName = try container.decodeIfPresent(String.self, forKey: .cityName) ?? ""
        self.geoAddress = try container.decodeIfPresent(String.self, forKey: .geoAddress) ?? ""
        self.pricePerDay = try container.decodeIfPresent(Double.self, forKey: .pricePerDay) ?? 0.0
        self.mainImageUrl = try container.decodeIfPresent(String.self, forKey: .mainImageUrl)
        self.statusText = try container.decodeIfPresent(String.self, forKey: .statusText) ?? ""
    }

    init(id: Int?, carName: String?, averageRating: Double?, cityName: String?, geoAddress: String?, pricePerDay: Double?, mainImageUrl: String?, statusText: String?) {
        self.id = id
        self.carName = carName
        self.averageRating = averageRating
        self.cityName = cityName
        self.geoAddress = geoAddress
        self.pricePerDay = pricePerDay
        self.mainImageUrl = mainImageUrl
        self.statusText = statusText
    }
}
