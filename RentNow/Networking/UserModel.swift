//
//  UserModel.swift
//  RentNow
//

import Foundation

// MARK: - User

struct User: Codable {
    var id: String?
    var fullName: String?
    var email: String?
    var phoneNumber: String?
    var profilePicture: String?
    var allowNotify: Bool?
    var token: String?
    var cityName: String?
    var cityId: Int?
    var countryId: Int?
    var countryName: String?
    var language: String?
    var packageId: Int?
    var packageName: String?

    // Local storage (not from API)
    var lat: String?
    var lng: String?
    var mapDesc: String?

    init() {}

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.fullName = try container.decodeIfPresent(String.self, forKey: .fullName) ?? ""
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber) ?? ""
        self.profilePicture = try container.decodeIfPresent(String.self, forKey: .profilePicture) ?? ""
        self.allowNotify = try container.decodeIfPresent(Bool.self, forKey: .allowNotify)
        self.token = try container.decodeIfPresent(String.self, forKey: .token)
        self.cityName = try container.decodeIfPresent(String.self, forKey: .cityName) ?? ""
        self.cityId = try container.decodeIfPresent(Int.self, forKey: .cityId)
        self.countryId = try container.decodeIfPresent(Int.self, forKey: .countryId)
        self.countryName = try container.decodeIfPresent(String.self, forKey: .countryName) ?? ""
        self.language = try container.decodeIfPresent(String.self, forKey: .language) ?? ""
        self.packageId = try container.decodeIfPresent(Int.self, forKey: .packageId)
        self.packageName = try container.decodeIfPresent(String.self, forKey: .packageName) ?? ""
        self.lat = try container.decodeIfPresent(String.self, forKey: .lat)
        self.lng = try container.decodeIfPresent(String.self, forKey: .lng)
        self.mapDesc = try container.decodeIfPresent(String.self, forKey: .mapDesc)
    }
}
