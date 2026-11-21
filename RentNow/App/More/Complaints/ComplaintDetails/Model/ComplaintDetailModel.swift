//
//  ComplaintDetailModel.swift
//  RentNow
//

import Foundation

struct ComplaintDetailData: Codable {
    let id: Int?
    let title: String?
    let message: String?
    let attachment: String?
    let adminResponse: String?
    let isAdminResponded: Bool?
    let creationDate: String?
    let number: Int?
    let orderNumber: Int?
    let orderDate: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        self.attachment = try container.decodeIfPresent(String.self, forKey: .attachment)
        self.adminResponse = try container.decodeIfPresent(String.self, forKey: .adminResponse)
        self.isAdminResponded = try container.decodeIfPresent(Bool.self, forKey: .isAdminResponded)
        self.creationDate = try container.decodeIfPresent(String.self, forKey: .creationDate) ?? ""
        self.number = try container.decodeIfPresent(Int.self, forKey: .number)
        self.orderNumber = try container.decodeIfPresent(Int.self, forKey: .orderNumber)
        self.orderDate = try container.decodeIfPresent(String.self, forKey: .orderDate)
    }
}
