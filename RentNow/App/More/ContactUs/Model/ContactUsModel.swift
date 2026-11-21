//
//  ContactUsModel.swift
//  RentNow
//

import Foundation

struct ContactInfoData: Codable {
    let phoneNumber: String?
    let email: String?
    let whatsAppNumber: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.phoneNumber = try container.decodeIfPresent(String.self, forKey: .phoneNumber) ?? ""
        self.email = try container.decodeIfPresent(String.self, forKey: .email) ?? ""
        self.whatsAppNumber = try container.decodeIfPresent(String.self, forKey: .whatsAppNumber) ?? ""
    }
}
