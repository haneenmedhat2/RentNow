//
//  RegisterModel.swift
//  Holool
//
//  Created by Elshamy on 09/11/2025.
//

import Combine
import UIKit


struct City: Codable, GeneralPickerModel {
    let id: Int
    let name: String
    let region: String?
    let regionId: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case region
        case regionId = "region_id"
    }

    init(id: Int, name: String, region: String?, regionId: Int?) {
        self.id = id
        self.name = name
        self.region = region
        self.regionId = regionId
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.region = try container.decodeIfPresent(String.self, forKey: .region)
        self.regionId = try container.decodeIfPresent(Int.self, forKey: .regionId)
    }
}

// MARK: - Device Info for Registration
struct DeviceInfo {
    static var deviceId: String {
        UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    }
    static var deviceType: String { "iOS" }
    static var projectName: String { "RentNow" }
}

// MARK: - Registration Form Data Response
struct RegistrationFormData: Codable {
    let countries: [APICountry]
    let termsAndConditions: String?
    let privacyPolicy: String?

    func toCountries() -> [Country] {
        let mapped = countries.map { $0.toCountry() }
        SVGImageCache.shared.preload(urls: mapped.compactMap { $0.image })
        return mapped
    }
}

// MARK: - API Country Model
struct APICountry: Codable {
    let id: Int
    let name: String
    let phoneCode: String
    let imageUrl: String

    // Convert API Country to existing Country model
    func toCountry() -> Country {
        return Country(
            id: self.id,
            name: self.name,
            key: self.phoneCode,           // phoneCode → key
            image: self.imageUrl,          // imageUrl → image
            currency: nil,
            isSelected: false
        )
    }
}


