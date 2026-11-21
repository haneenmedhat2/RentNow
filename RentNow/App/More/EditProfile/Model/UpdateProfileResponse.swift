//
//  UpdateProfileResponse.swift
//  RentNow
//

import Foundation

// MARK: - Update Profile Data
struct UpdateProfileData: Codable {
    let id: String?
    let fullName: String?
    let email: String?
    let phoneNumber: String?
    let profilePicture: String?
    let allowNotify: Bool?
    let token: String?
    let cityName: String?
    let cityId: Int?
    let countryId: Int?
    let countryName: String?
    let language: String?
    let packageId: Int?
    let packageName: String?

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
        self.language = try container.decodeIfPresent(String.self, forKey: .language)
        self.packageId = try container.decodeIfPresent(Int.self, forKey: .packageId)
        self.packageName = try container.decodeIfPresent(String.self, forKey: .packageName)
    }
}
