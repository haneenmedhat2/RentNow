//
//  OrderModel.swift
//  RentNow
//
//  Created by Claude on 2026-02-09.
//

import Foundation

// MARK: - Order Filter Type
enum OrderFilterType: String, CaseIterable {
    case new = "New"
    case current = "Currently"
    case ended = "Ended"

    var title: String {
        switch self {
        case .new: return "New Orders".localized
        case .current: return "Current Orders".localized
        case .ended: return "Ended Orders".localized
        }
    }
}

// MARK: - Order Item
struct OrderItem: Codable, Identifiable {
    var id: Int { orderId ?? 0 }

    let orderId: Int?
    let orderNumber: String?
    let providerName: String?
    let providerImage: String?
    let creationDate: String?
    let creationDateFormatted: String?
    let orderStatus: String?
    let orderStatusText: String?
    let backgroundColor:String?
    let statusColor:String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.orderId = try container.decodeIfPresent(Int.self, forKey: .orderId)
        self.orderNumber = try container.decodeIfPresent(String.self, forKey: .orderNumber) ?? ""
        self.providerName = try container.decodeIfPresent(String.self, forKey: .providerName) ?? ""
        self.providerImage = try container.decodeIfPresent(String.self, forKey: .providerImage)
        self.creationDate = try container.decodeIfPresent(String.self, forKey: .creationDate) ?? ""
        self.creationDateFormatted = try container.decodeIfPresent(String.self, forKey: .creationDateFormatted) ?? ""
        self.orderStatus = try container.decodeIfPresent(String.self, forKey: .orderStatus) ?? ""
        self.orderStatusText = try container.decodeIfPresent(String.self, forKey: .orderStatusText) ?? ""
        self.backgroundColor = try container.decodeIfPresent(String.self, forKey: .backgroundColor) ?? ""
        self.statusColor = try container.decodeIfPresent(String.self, forKey: .statusColor) ?? ""
    }
}
