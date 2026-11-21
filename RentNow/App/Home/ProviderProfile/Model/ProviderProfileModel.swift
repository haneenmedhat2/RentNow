//
//  ProviderProfileModel.swift
//  RentNow
//

import Foundation

struct OwnerAdvertisementsData: Codable {
    let id: String?
    let name: String?
    let imageUrl: String?
    let advertisements: [Advertisement]?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl) ?? ""
        self.advertisements = try container.decodeIfPresent([Advertisement].self, forKey: .advertisements) ?? []
    }
}
