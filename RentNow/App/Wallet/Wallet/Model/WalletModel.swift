//
//  WalletModel.swift
//  RentNow
//
//  Created by Claude on 2026-02-08.
//

import Foundation

// MARK: - Active Subscription
struct ActiveSubscription: Codable {
    let id: Int?
    let packageId: Int?
    let packageName: String?
    let description: String?
    let descriptionAr: String?
    let descriptionEn: String?
    let startAt: String?
    let endAt: String?
    let status: String?
    let isActive: Bool?
    let isExpired: Bool?
    let discountPercentage: Double?
    let price: Double?
    let durationInDays: Int?
    let remainingWaivedDeliveryFeesOrders: Int?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.packageId = try container.decodeIfPresent(Int.self, forKey: .packageId)
        self.packageName = try container.decodeIfPresent(String.self, forKey: .packageName) ?? ""
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.descriptionAr = try container.decodeIfPresent(String.self, forKey: .descriptionAr) ?? ""
        self.descriptionEn = try container.decodeIfPresent(String.self, forKey: .descriptionEn) ?? ""
        self.startAt = try container.decodeIfPresent(String.self, forKey: .startAt) ?? ""
        self.endAt = try container.decodeIfPresent(String.self, forKey: .endAt) ?? ""
        self.status = try container.decodeIfPresent(String.self, forKey: .status) ?? ""
        self.isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive)
        self.isExpired = try container.decodeIfPresent(Bool.self, forKey: .isExpired)
        self.discountPercentage = try container.decodeIfPresent(Double.self, forKey: .discountPercentage) ?? 0.0
        self.price = try container.decodeIfPresent(Double.self, forKey: .price) ?? 0.0
        self.durationInDays = try container.decodeIfPresent(Int.self, forKey: .durationInDays) ?? 0
        self.remainingWaivedDeliveryFeesOrders = try container.decodeIfPresent(Int.self, forKey: .remainingWaivedDeliveryFeesOrders) ?? 0
    }
}

// MARK: - Package Item
struct PackageItem: Codable, Identifiable {
    let id: Int?
    let name: String?
    let price: Double?
    let durationInDays: Int?
    let discountPercentage: Double?
    let isDeliveryFeesWaived: Bool?
    let freeOperationsCount: Int?
    let waivedDeliveryFeesOrdersCount: Int?
    let description: String?
    let descriptionAr: String?
    let descriptionEn: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.price = try container.decodeIfPresent(Double.self, forKey: .price) ?? 0.0
        self.durationInDays = try container.decodeIfPresent(Int.self, forKey: .durationInDays) ?? 0
        self.discountPercentage = try container.decodeIfPresent(Double.self, forKey: .discountPercentage) ?? 0.0
        self.isDeliveryFeesWaived = try container.decodeIfPresent(Bool.self, forKey: .isDeliveryFeesWaived)
        self.freeOperationsCount = try container.decodeIfPresent(Int.self, forKey: .freeOperationsCount) ?? 0
        self.waivedDeliveryFeesOrdersCount = try container.decodeIfPresent(Int.self, forKey: .waivedDeliveryFeesOrdersCount) ?? 0
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        self.descriptionAr = try container.decodeIfPresent(String.self, forKey: .descriptionAr) ?? ""
        self.descriptionEn = try container.decodeIfPresent(String.self, forKey: .descriptionEn) ?? ""
    }
}

// MARK: - Subscribe Response
struct SubscribeResponse: Decodable {
    let payment: PayOrderData

    enum CodingKeys: String, CodingKey {
        case subscriptionRequestId, paymentUrl, paymentUrlExpiry, amount, transactionId
    }
    let subscriptionRequestId: Int?
    let paymentUrl: String?
    let paymentUrlExpiry: String?
    let amount: Double?
    let transactionId: String?

    init(from decoder: any Decoder) throws {
        payment = try PayOrderData(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.subscriptionRequestId = try container.decodeIfPresent(Int.self, forKey: .subscriptionRequestId)
        self.paymentUrl = try container.decodeIfPresent(String.self, forKey: .paymentUrl) ?? ""
        self.paymentUrlExpiry = try container.decodeIfPresent(String.self, forKey: .paymentUrlExpiry) ?? ""
        self.amount = try container.decodeIfPresent(Double.self, forKey: .amount) ?? 0.0
        self.transactionId = try container.decodePaymentTransactionIDIfPresent(forKey: .transactionId)
    }
}
