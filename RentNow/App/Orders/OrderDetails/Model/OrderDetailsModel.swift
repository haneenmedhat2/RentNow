//
//  OrderDetailsModel.swift
//  RentNow
//

import Foundation

// MARK: - Order Details Data
struct OrderDetailsData: Codable {
    let order: OrderData?
    let providerInfo: ProviderInfoData?
    let buttonActions: ButtonActionsData?
    let advertisementInfo: AdvertisementInfoData?
    let orderInfo: OrderInfoData?
    let deliveryInfo: DeliveryInfoData?
    let returnPickupInfo: ReturnPickupInfoData?
    let paymentInfo: PaymentInfoData?
    let handoverData: OdometerData?
    let returnData: OdometerData?
    let extraKilometersData: ExtraKilometersData?
    let rate:RateData?
    let userInfo:userInfoData?
    let viewerRole: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.order = try container.decodeIfPresent(OrderData.self, forKey: .order)
        self.providerInfo = try container.decodeIfPresent(ProviderInfoData.self, forKey: .providerInfo)
        self.userInfo = try container.decodeIfPresent(userInfoData.self, forKey: .userInfo)
        self.buttonActions = try container.decodeIfPresent(ButtonActionsData.self, forKey: .buttonActions)
        self.advertisementInfo = try container.decodeIfPresent(AdvertisementInfoData.self, forKey: .advertisementInfo)
        self.orderInfo = try container.decodeIfPresent(OrderInfoData.self, forKey: .orderInfo)
        self.deliveryInfo = try container.decodeIfPresent(DeliveryInfoData.self, forKey: .deliveryInfo)
        self.returnPickupInfo = try container.decodeIfPresent(ReturnPickupInfoData.self, forKey: .returnPickupInfo)
        self.paymentInfo = try container.decodeIfPresent(PaymentInfoData.self, forKey: .paymentInfo)
        self.handoverData = try container.decodeIfPresent(OdometerData.self, forKey: .handoverData)
        self.returnData = try container.decodeIfPresent(OdometerData.self, forKey: .returnData)
        self.extraKilometersData = try container.decodeIfPresent(ExtraKilometersData.self, forKey: .extraKilometersData)
        self.rate = try container.decodeIfPresent(RateData.self, forKey: .rate)
        self.viewerRole = try container.decodeIfPresent(String.self, forKey: .viewerRole)
    }
}

// MARK: - Order Data
struct OrderData: Codable {
    let orderId: Int?
    let orderNumber: String?
    let status: Int?
    let statusText: String?
    let creationDate: String?
    let creationDateFormatted: String?
    let statusColor: String?
    let backgroundColor: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.orderId = try container.decodeIfPresent(Int.self, forKey: .orderId)
        self.orderNumber = try container.decodeIfPresent(String.self, forKey: .orderNumber) ?? ""
        self.status = try container.decodeIfPresent(Int.self, forKey: .status)
        self.statusText = try container.decodeIfPresent(String.self, forKey: .statusText) ?? ""
        self.creationDate = try container.decodeIfPresent(String.self, forKey: .creationDate) ?? ""
        self.creationDateFormatted = try container.decodeIfPresent(String.self, forKey: .creationDateFormatted) ?? ""
        self.statusColor = try container.decodeIfPresent(String.self, forKey: .statusColor) ?? ""
        self.backgroundColor = try container.decodeIfPresent(String.self, forKey: .backgroundColor) ?? ""
    }
}

// MARK: - Provider Info
struct ProviderInfoData: Codable {
    let providerId: String?
    let providerName: String?
    let providerImage: String?
    let profileImage:String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.providerId = try container.decodeIfPresent(String.self, forKey: .providerId)
        self.providerName = try container.decodeIfPresent(String.self, forKey: .providerName) ?? ""
        self.providerImage = try container.decodeIfPresent(String.self, forKey: .providerImage)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)

    }
}


// MARK: - Provider Info
struct userInfoData: Codable {
    let userId: String?
    let userName: String?
    let profileImage:String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decodeIfPresent(String.self, forKey: .userId)
        self.userName = try container.decodeIfPresent(String.self, forKey: .userName) ?? ""
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage)

    }
}
// MARK: - Button Actions
struct ButtonActionsData: Codable {
    let isNew: Bool?
    let isPayment: Bool?
    let isPrepared: Bool?
    let isDelivered: Bool?
    let isReceived: Bool?
    let isRate: Bool?
    let isExceededKilometersPayment: Bool?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isNew = try container.decodeIfPresent(Bool.self, forKey: .isNew)
        self.isPayment = try container.decodeIfPresent(Bool.self, forKey: .isPayment)
        self.isPrepared = try container.decodeIfPresent(Bool.self, forKey: .isPrepared)
        self.isDelivered = try container.decodeIfPresent(Bool.self, forKey: .isDelivered)
        self.isReceived = try container.decodeIfPresent(Bool.self, forKey: .isReceived)
        self.isRate = try container.decodeIfPresent(Bool.self, forKey: .isRate)
        self.isExceededKilometersPayment = try container.decodeIfPresent(Bool.self, forKey: .isExceededKilometersPayment)
    }
}

// MARK: - Advertisement Info
struct AdvertisementInfoData: Codable {
    let advertisementId: Int?
    let name: String?
    let images: [String]?
    let city: String?
    let address: String?
    let fuelType: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.advertisementId = try container.decodeIfPresent(Int.self, forKey: .advertisementId)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.images = try container.decodeIfPresent([String].self, forKey: .images) ?? []
        self.city = try container.decodeIfPresent(String.self, forKey: .city) ?? ""
        self.address = try container.decodeIfPresent(String.self, forKey: .address) ?? ""
        self.fuelType = try container.decodeIfPresent(String.self, forKey: .fuelType) ?? ""
    }
}

// MARK: - Order Info
struct OrderInfoData: Codable {
    let startDate: String?
    let endDate: String?
    let bookingTime: String?
    let bookingTimeFormatted: String?
    let rentalDateRangeFormatted: String?
    let numberOfDays: Int?
    let minKilometers: Int?
    let maxKilometers: Int?
    let extraKilometerPrice: Double?
    let insurancePrice: Double?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.startDate = try container.decodeIfPresent(String.self, forKey: .startDate) ?? ""
        self.endDate = try container.decodeIfPresent(String.self, forKey: .endDate) ?? ""
        self.bookingTime = try container.decodeIfPresent(String.self, forKey: .bookingTime) ?? ""
        self.bookingTimeFormatted = try container.decodeIfPresent(String.self, forKey: .bookingTimeFormatted)
        self.rentalDateRangeFormatted = try container.decodeIfPresent(String.self, forKey: .rentalDateRangeFormatted)
        self.numberOfDays = try container.decodeIfPresent(Int.self, forKey: .numberOfDays) ?? 0
        self.minKilometers = try container.decodeIfPresent(Int.self, forKey: .minKilometers) ?? 0
        self.maxKilometers = try container.decodeIfPresent(Int.self, forKey: .maxKilometers) ?? 0
        self.extraKilometerPrice = try container.decodeIfPresent(Double.self, forKey: .extraKilometerPrice) ?? 0.0
        self.insurancePrice = try container.decodeIfPresent(Double.self, forKey: .insurancePrice) ?? 0.0
    }
}

// MARK: - Delivery Info
struct DeliveryInfoData: Codable {
    let deliveryMethod: String?
    let deliveryLocation: String?
    let deliveryLatitude: Double?
    let deliveryLongitude: Double?
    let notes: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.deliveryMethod = try container.decodeIfPresent(String.self, forKey: .deliveryMethod) ?? ""
        self.deliveryLocation = try container.decodeIfPresent(String.self, forKey: .deliveryLocation) ?? ""
        self.deliveryLatitude = try container.decodeIfPresent(Double.self, forKey: .deliveryLatitude)
        self.deliveryLongitude = try container.decodeIfPresent(Double.self, forKey: .deliveryLongitude)
        self.notes = try container.decodeIfPresent(String.self, forKey: .notes) ?? ""
    }
}

// MARK: - Return Pickup Info
struct ReturnPickupInfoData: Codable {
    let returnPickupMethod: String?
    let returnPickupLocation: String?
    let returnPickupLatitude: Double?
    let returnPickupLongitude: Double?
    let notes: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.returnPickupMethod = try container.decodeIfPresent(String.self, forKey: .returnPickupMethod) ?? ""
        self.returnPickupLocation = try container.decodeIfPresent(String.self, forKey: .returnPickupLocation) ?? ""
        self.returnPickupLatitude = try container.decodeIfPresent(Double.self, forKey: .returnPickupLatitude)
        self.returnPickupLongitude = try container.decodeIfPresent(Double.self, forKey: .returnPickupLongitude)
        self.notes = try container.decodeIfPresent(String.self, forKey: .notes) ?? ""
    }
}

// MARK: - Payment Info
struct PaymentInfoData: Codable {
    let paymentMethod: String?
    let paymentMethodId: Int?
    let paymentProvider: PaymentProvider?
    let finalTotal: Double?
    let currency: String?
    let paymentStatus: OrderPaymentStatus?
    let paymentStatusText: String?
    let lastPaymentTransactionId: String?
    let paymentRejectionReason: String?
    let canChangePaymentMethod: Bool?
    let rentPrice: Double?
    let deliveryPrice: Double?
    let tax: Double?
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

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.paymentMethod = try container.decodeIfPresent(String.self, forKey: .paymentMethod) ?? ""
        self.paymentMethodId = try container.decodeIfPresent(Int.self, forKey: .paymentMethodId)
        self.paymentProvider = try container.decodeIfPresent(PaymentProvider.self, forKey: .paymentProvider)
        self.finalTotal = try container.decodeIfPresent(Double.self, forKey: .finalTotal)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency) ?? ""
        self.paymentStatus = try container.decodeIfPresent(OrderPaymentStatus.self, forKey: .paymentStatus)
        self.paymentStatusText = try container.decodeIfPresent(String.self, forKey: .paymentStatusText) ?? ""
        self.lastPaymentTransactionId = try container.decodePaymentTransactionIDIfPresent(forKey: .lastPaymentTransactionId)
        self.paymentRejectionReason = try container.decodeIfPresent(String.self, forKey: .paymentRejectionReason) ?? ""
        self.canChangePaymentMethod = try container.decodeIfPresent(Bool.self, forKey: .canChangePaymentMethod)
        self.rentPrice = try container.decodeIfPresent(Double.self, forKey: .rentPrice) ?? 0.0
        self.deliveryPrice = try container.decodeIfPresent(Double.self, forKey: .deliveryPrice) ?? 0.0
        self.tax = try container.decodeIfPresent(Double.self, forKey: .tax) ?? 0.0
        self.pricePerDay = try container.decodeIfPresent(Double.self, forKey: .pricePerDay) ?? 0.0
        self.numberOfDays = try container.decodeIfPresent(Int.self, forKey: .numberOfDays) ?? 0
        self.rentalCost = try container.decodeIfPresent(Double.self, forKey: .rentalCost) ?? 0.0
        self.deliveryCost = try container.decodeIfPresent(Double.self, forKey: .deliveryCost) ?? 0.0
        self.returnPickupCost = try container.decodeIfPresent(Double.self, forKey: .returnPickupCost) ?? 0.0
        self.insuranceValue = try container.decodeIfPresent(Double.self, forKey: .insuranceValue) ?? 0.0
        self.featuresCost = try container.decodeIfPresent(Double.self, forKey: .featuresCost) ?? 0.0
        self.discountAmount = try container.decodeIfPresent(Double.self, forKey: .discountAmount)
        self.appFeesAmount = try container.decodeIfPresent(Double.self, forKey: .appFeesAmount) ?? 0.0
        self.totalBeforeVat = try container.decodeIfPresent(Double.self, forKey: .totalBeforeVat) ?? 0.0
        self.vatPercentege = try container.decodeIfPresent(Double.self, forKey: .vatPercentege) ?? 0.0
        self.vatValue = try container.decodeIfPresent(Double.self, forKey: .vatValue) ?? 0.0
        self.total = try container.decodeIfPresent(Double.self, forKey: .total) ?? 0.0
    }
}

// MARK: - Odometer Data
struct OdometerData: Codable {
    let odometerPhoto: String?
    let odometerReading: Double?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.odometerPhoto = try container.decodeIfPresent(String.self, forKey: .odometerPhoto)
        self.odometerReading = try container.decodeIfPresent(Double.self, forKey: .odometerReading) ?? 0.0
    }
}

// MARK: - Extra Kilometers Data
struct ExtraKilometersData: Codable {
    let message: String?
    let extraKilometers: Int?
    let pricePerKilometer: Double?
    let total: Double?
    let canPayExceededKilometers: Bool?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        self.extraKilometers = try container.decodeIfPresent(Int.self, forKey: .extraKilometers) ?? 0
        self.pricePerKilometer = try container.decodeIfPresent(Double.self, forKey: .pricePerKilometer) ?? 0.0
        self.total = try container.decodeIfPresent(Double.self, forKey: .total) ?? 0.0
        self.canPayExceededKilometers = try container.decodeIfPresent(Bool.self, forKey: .canPayExceededKilometers)
    }
}

// MARK: - Pay Order Data
struct RateData:Codable {
    var rate:Double?
    var image:String?
    var name:String?
    var date:String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rate = try container.decodeIfPresent(Double.self, forKey: .rate)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.date = try container.decodeIfPresent(String.self, forKey: .date)
    }
}
