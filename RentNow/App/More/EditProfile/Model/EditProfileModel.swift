//
//  EditProfileModel.swift
//  RentNow
//

import Foundation

// MARK: - Edit Profile Data
struct EditProfileData: Codable {
    let userInfo: EditProfileUserInfo?
    let countries: [EditProfileCountry]?
    let cities: [EditProfileCity]?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userInfo = try container.decodeIfPresent(EditProfileUserInfo.self, forKey: .userInfo)
        self.countries = try container.decodeIfPresent([EditProfileCountry].self, forKey: .countries) ?? []
        self.cities = try container.decodeIfPresent([EditProfileCity].self, forKey: .cities) ?? []
    }
}

// MARK: - User Info
struct EditProfileUserInfo: Codable {
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

// MARK: - Country
struct EditProfileCountry: Codable, GeneralPickerModel {
    let id: Int
    let name: String
    let currency: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency)
    }
}

// MARK: - City
struct EditProfileCity: Codable, GeneralPickerModel {
    let id: Int
    let name: String
    let latitude: Double?
    let longitude: Double?
    let countryId: Int?
    let countryName: String?
    let deliveryDefaultCost: Double?

    init(id: Int, name: String) {
        self.id = id
        self.name = name
        self.latitude = nil
        self.longitude = nil
        self.countryId = nil
        self.countryName = nil
        self.deliveryDefaultCost = nil
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        self.countryId = try container.decodeIfPresent(Int.self, forKey: .countryId)
        self.countryName = try container.decodeIfPresent(String.self, forKey: .countryName)
        self.deliveryDefaultCost = try container.decodeIfPresent(Double.self, forKey: .deliveryDefaultCost)
    }
}
