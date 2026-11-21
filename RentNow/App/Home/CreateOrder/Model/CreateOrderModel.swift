//
//  CreateOrderModel.swift
//  RentNow
//

import Foundation

// MARK: - Order Page Data
struct OrderPageData: Codable {
    let adDetails: OrderAdDetails?
    let insuranceValue: Double?
    let paymentMethods: [OrderPaymentMethod]?
    let paymentOptions: [OrderPaymentOption]?
    let additionalFeatures: [OrderAdditionalFeature]?
    let cancellationAndDelayTerms: String?
    let appFees: Double?
    let userPackage: UserPackage?
    let rentalPolicy: RentalPolicy?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.adDetails = try container.decodeIfPresent(OrderAdDetails.self, forKey: .adDetails)
        self.insuranceValue = try container.decodeIfPresent(Double.self, forKey: .insuranceValue) ?? 0.0
        self.paymentMethods = try container.decodeIfPresent([OrderPaymentMethod].self, forKey: .paymentMethods)
        self.paymentOptions = try container.decodeIfPresent([OrderPaymentOption].self, forKey: .paymentOptions)
        self.additionalFeatures = try container.decodeIfPresent([OrderAdditionalFeature].self, forKey: .additionalFeatures) ?? []
        self.cancellationAndDelayTerms = try container.decodeIfPresent(String.self, forKey: .cancellationAndDelayTerms) ?? ""
        self.appFees = try container.decodeIfPresent(Double.self, forKey: .appFees) ?? 0.0
        self.userPackage = try container.decodeIfPresent(UserPackage.self, forKey: .userPackage)
        self.rentalPolicy = try container.decodeIfPresent(RentalPolicy.self, forKey: .rentalPolicy)
    }
}

// MARK: - User Package
struct UserPackage: Codable {
    let packageId: Int?
    let packageName: String?
    let discountPercentage: Double?
    let deliveryFeesWaived: Bool?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.packageId = try container.decodeIfPresent(Int.self, forKey: .packageId)
        self.packageName = try container.decodeIfPresent(String.self, forKey: .packageName) ?? ""
        self.discountPercentage = try container.decodeIfPresent(Double.self, forKey: .discountPercentage) ?? 0.0
        self.deliveryFeesWaived = try container.decodeIfPresent(Bool.self, forKey: .deliveryFeesWaived)
    }
}

// MARK: - Ad Details
struct OrderAdDetails: Codable {
    let id: Int?
    let name: String?
    let city: String?
    let geoAddress: String?
    let fuel: String?
    let fuelName: String?
    let latitude: Double?
    let longitude: Double?
    let mainImage: String?
    let pricePerDay: Double?
    let isDeliveryToRenterLocationEnabled: Bool?
    let isReceivedFromRenterLocationEnabled: Bool?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.city = try container.decodeIfPresent(String.self, forKey: .city) ?? ""
        self.geoAddress = try container.decodeIfPresent(String.self, forKey: .geoAddress)
        self.fuel = try container.decodeIfPresent(String.self, forKey: .fuel)
        self.fuelName = try container.decodeIfPresent(String.self, forKey: .fuelName)
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        self.mainImage = try container.decodeIfPresent(String.self, forKey: .mainImage) ?? ""
        self.pricePerDay = try container.decodeIfPresent(Double.self, forKey: .pricePerDay) ?? 0.0
        self.isDeliveryToRenterLocationEnabled = try container.decodeIfPresent(Bool.self, forKey: .isDeliveryToRenterLocationEnabled)
        self.isReceivedFromRenterLocationEnabled = try container.decodeIfPresent(Bool.self, forKey: .isReceivedFromRenterLocationEnabled)
    }
}

// MARK: - Rental Policy
struct RentalPolicy: Codable {
    let insuranceValue: Double?
    let minKilometesUsage: Double?
    let maxKilometesUsage: Double?
    let extraKilometerPrice: Double?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.insuranceValue = try container.decodeIfPresent(Double.self, forKey: .insuranceValue) ?? 0.0
        self.minKilometesUsage = try container.decodeIfPresent(Double.self, forKey: .minKilometesUsage) ?? 0.0
        self.maxKilometesUsage = try container.decodeIfPresent(Double.self, forKey: .maxKilometesUsage) ?? 0.0
        self.extraKilometerPrice = try container.decodeIfPresent(Double.self, forKey: .extraKilometerPrice) ?? 0.0
    }
}

// MARK: - Order Payment Summary
struct OrderPaymentSummary: Codable {
    let pricePerDay: Double?
    let numberOfDays: Int?
    let rentalCost: Double?
    let deliveryCost: Double?
    let returnPickupCost: Double?
    let insuranceValue: Double?
    let featuresCost: Double?
    let discountAmount: Double?
    let appFeesAmount: Double?
    let totalBeforeVat: Double?
    let vatPercentege: Double?
    let vatValue: Double?
    let total: Double?
    let currency: String?
    let paymentMethods: [OrderPaymentMethod]?
    let paymentOptions: [OrderPaymentOption]?

    enum CodingKeys: String, CodingKey {
        case currency, paymentMethods, paymentOptions
        case pricePerDay, numberOfDays, rentalCost, deliveryCost
        case returnPickupCost, insuranceValue, featuresCost, discountAmount
        case appFeesAmount, vatPercentege, vatValue
        case totalBeforeVat = "totalPriceBeforeVat"
        case total = "totalPrice"
    }

    init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        self.currency = try c.decodeIfPresent(String.self, forKey: .currency) ?? ""
        self.paymentMethods = try c.decodeIfPresent([OrderPaymentMethod].self, forKey: .paymentMethods)
        self.paymentOptions = try c.decodeIfPresent([OrderPaymentOption].self, forKey: .paymentOptions)
        self.pricePerDay      = try c.decodeIfPresent(Double.self, forKey: .pricePerDay)      ?? 0
        self.numberOfDays     = try c.decodeIfPresent(Int.self,    forKey: .numberOfDays)     ?? 0
        self.rentalCost       = try c.decodeIfPresent(Double.self, forKey: .rentalCost)       ?? 0
        self.deliveryCost     = try c.decodeIfPresent(Double.self, forKey: .deliveryCost)     ?? 0
        self.returnPickupCost = try c.decodeIfPresent(Double.self, forKey: .returnPickupCost) ?? 0
        self.insuranceValue   = try c.decodeIfPresent(Double.self, forKey: .insuranceValue)   ?? 0
        self.featuresCost     = try c.decodeIfPresent(Double.self, forKey: .featuresCost)     ?? 0
        self.discountAmount   = try c.decodeIfPresent(Double.self, forKey: .discountAmount)
        self.appFeesAmount    = try c.decodeIfPresent(Double.self, forKey: .appFeesAmount)    ?? 0
        self.totalBeforeVat   = try c.decodeIfPresent(Double.self, forKey: .totalBeforeVat)   ?? 0
        self.vatPercentege    = try c.decodeIfPresent(Double.self, forKey: .vatPercentege)    ?? 0
        self.vatValue         = try c.decodeIfPresent(Double.self, forKey: .vatValue)         ?? 0
        self.total            = try c.decodeIfPresent(Double.self, forKey: .total)            ?? 0
    }
}

// MARK: - Payment Method
struct OrderPaymentMethod: Codable, Identifiable {
    var id: String { value ?? UUID().uuidString }
    let disabled: Bool?
    let group: String?
    let selected: Bool?
    let text: String?
    let value: String?

    var paymentOption: OrderPaymentOption? {
        guard let value, let methodId = Int(value) else { return nil }
        return OrderPaymentOption(id: methodId, name: text ?? "", isAvailable: disabled != true)
    }

    init(disabled: Bool? = nil, group: String? = nil, selected: Bool? = nil, text: String?, value: String?) {
        self.disabled = disabled
        self.group = group
        self.selected = selected
        self.text = text
        self.value = value
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.disabled = try container.decodeIfPresent(Bool.self, forKey: .disabled)
        self.group = try container.decodeIfPresent(String.self, forKey: .group)
        self.selected = try container.decodeIfPresent(Bool.self, forKey: .selected)
        self.text = try container.decodeIfPresent(String.self, forKey: .text) ?? ""
        self.value = try container.decodeIfPresent(String.self, forKey: .value) ?? ""
    }
}

// MARK: - Additional Feature
struct OrderAdditionalFeature: Codable, Identifiable {
    let id: Int?
    let name: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
}

// MARK: - Create Order Response
struct CreateOrderResponse: Codable {
    let orderId: Int?
    let orderNumber: String?
    let totalPrice: Double?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.orderId = try container.decodeIfPresent(Int.self, forKey: .orderId)
        self.orderNumber = try container.decodeIfPresent(String.self, forKey: .orderNumber) ?? ""
        self.totalPrice = try container.decodeIfPresent(Double.self, forKey: .totalPrice) ?? 0.0
    }
}

// MARK: - Delivery Method
enum DeliveryMethod: String, CaseIterable {
    case pickupFromLocation = "1"
    case delivery = "2"

    var title: String {
        switch self {
        case .pickupFromLocation:
            return "Pickup from location".localized
        case .delivery:
            return "Delivery".localized
        }
    }
}
