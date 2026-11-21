//
//  CustomerOrdersModel.swift
//  RentNow
//
//  Created by Claude Code
//

import Foundation

// MARK: - Customer Order Filter Type
enum CustomerOrderFilterType: String, CaseIterable {
    case currently = "Currently"
    case ended = "Ended"

    var title: String {
        switch self {
        case .currently: return "Current Orders".localized
        case .ended: return "Ended Orders".localized
        }
    }
}

// MARK: - Customer Order Item
struct CustomerOrderItem: Codable, Identifiable {
    let id: Int?
    let orderId: Int?
    let orderNumber: String?
    let providerName: String?
    let providerImage: String?
    let creationDate: String?
    let creationDateFormatted: String?
    let orderStatus: String?
    let orderStatusText: String?
    let statusColor: String?
    let backgroundColor: String?
    let userName:String?
    let userImage:String?
    var identifier: Int { orderId ?? id ?? UUID().hashValue }

    enum CodingKeys: String, CodingKey {
        case orderId, orderNumber, providerName, providerImage, creationDate, creationDateFormatted, orderStatus, orderStatusText, statusColor, backgroundColor , userName ,userImage
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .orderId)
        self.orderId = try container.decodeIfPresent(Int.self, forKey: .orderId)
        self.orderNumber = try container.decodeIfPresent(String.self, forKey: .orderNumber) ?? ""
        self.providerName = try container.decodeIfPresent(String.self, forKey: .providerName) ?? ""
        self.providerImage = try container.decodeIfPresent(String.self, forKey: .providerImage)
        self.creationDate = try container.decodeIfPresent(String.self, forKey: .creationDate) ?? ""
        self.creationDateFormatted = try container.decodeIfPresent(String.self, forKey: .creationDateFormatted) ?? ""
        self.orderStatus = try container.decodeIfPresent(String.self, forKey: .orderStatus) ?? ""
        self.orderStatusText = try container.decodeIfPresent(String.self, forKey: .orderStatusText) ?? ""
        self.statusColor = try container.decodeIfPresent(String.self, forKey: .statusColor) ?? ""
        self.backgroundColor = try container.decodeIfPresent(String.self, forKey: .backgroundColor) ?? ""
        self.userName = try container.decodeIfPresent(String.self, forKey: .userName) ?? ""
        self.userImage = try container.decodeIfPresent(String.self, forKey: .userImage)
    }

    init(orderId: Int?, orderNumber: String?, providerName: String?, providerImage: String?, creationDate: String?, creationDateFormatted: String? = nil, orderStatus: String?, orderStatusText: String?, statusColor: String? = nil, backgroundColor: String? = nil, userName: String?, userImage: String?) {
        self.id = orderId
        self.orderId = orderId
        self.orderNumber = orderNumber
        self.providerName = providerName
        self.providerImage = providerImage
        self.creationDate = creationDate
        self.creationDateFormatted = creationDateFormatted
        self.orderStatus = orderStatus
        self.orderStatusText = orderStatusText
        self.statusColor = statusColor
        self.backgroundColor = backgroundColor
        self.userImage = userImage
        self.userName = userName
    }
}
