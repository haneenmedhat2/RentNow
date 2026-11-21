//
//  ProfileInfoModel.swift
//  RentNow
//

import Foundation

struct ProfileInfoData: Codable {
    let image: String?
    let name: String?
    let phoneNumber: String?
    let email: String?
    let countryName: String?
    let cityName: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.image = try container.decodeIfPresent(String.self, forKey: .image) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber) ?? ""
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.countryName = try container.decodeIfPresent(String.self, forKey: .countryName) ?? ""
        self.cityName = try container.decodeIfPresent(String.self, forKey: .cityName) ?? ""
    }
}
