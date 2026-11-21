//
//  MyRatingsModel.swift
//  RentNow
//

import Foundation

struct MyRateItem: Codable {
    let rateDetails: MyRateDetails?
    let adDetails: MyRateAdDetails?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rateDetails = try container.decodeIfPresent(MyRateDetails.self, forKey: .rateDetails)
        self.adDetails = try container.decodeIfPresent(MyRateAdDetails.self, forKey: .adDetails)
    }
}

struct MyRateDetails: Codable {
    let raterName: String?
    let ratingDate: String?
    let ratingCount: Double?
    let ratingDateFormatted:String?
    let raterImage:String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.raterName = try container.decodeIfPresent(String.self, forKey: .raterName) ?? ""
        self.ratingDate = try container.decodeIfPresent(String.self, forKey: .ratingDate)
        self.ratingCount = try container.decodeIfPresent(Double.self, forKey: .ratingCount) ?? 0.0
        self.ratingDateFormatted = try container.decodeIfPresent(String.self, forKey: .ratingDateFormatted) ?? ""
        self.raterImage = try container.decodeIfPresent(String.self, forKey: .raterImage) ?? ""

        
    }
}

struct MyRateAdDetails: Codable {
    let adName: String?
    let city: String?
    let address: String?
    let mainImage: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.adName = try container.decodeIfPresent(String.self, forKey: .adName) ?? ""
        self.city = try container.decodeIfPresent(String.self, forKey: .city) ?? ""
        self.address = try container.decodeIfPresent(String.self, forKey: .address) ?? ""
        self.mainImage = try container.decodeIfPresent(String.self, forKey: .mainImage) ?? ""
    }
}
