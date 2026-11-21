//
//  OrderBookingRequest.swift
//  RentNow
//

import Foundation

struct OrderBookingRequest: Equatable {
    let advertisementId: Int
    let dateFrom: String
    let dateTo: String
    let additionalFeatureIds: [Int]
    let paymentMethod: Int
    let deliveryMethod: Int
    let deliveryLatitude: Double?
    let deliveryLongitude: Double?
    let deliveryAirportId: Int?
    let deliveryNotes: String?
    let returnPickupMethod: Int
    let returnPickupLatitude: Double?
    let returnPickupLongitude: Double?
    let returnPickupAirportId: Int?
    let returnPickupNotes: String?

    var parameters: [String: Any?] {
        var body: [String: Any?] = [
            "AdvertisementId": advertisementId,
            "DateFrom": dateFrom,
            "DateTo": dateTo,
            "AdditionalFeatureIds": additionalFeatureIds,
            "PaymentMethod": paymentMethod,
            "DeliveryMethod": deliveryMethod,
            "DeliveryLatitude": deliveryLatitude.map { $0 as Any } ?? NSNull(),
            "DeliveryLongitude": deliveryLongitude.map { $0 as Any } ?? NSNull(),
            "DeliveryAirportId": deliveryAirportId.map { $0 as Any } ?? NSNull(),
            "ReturnPickupMethod": returnPickupMethod,
            "ReturnPickupLatitude": returnPickupLatitude.map { $0 as Any } ?? NSNull(),
            "ReturnPickupLongitude": returnPickupLongitude.map { $0 as Any } ?? NSNull(),
            "ReturnPickupAirportId": returnPickupAirportId.map { $0 as Any } ?? NSNull()
        ]
        if let notes = deliveryNotes, !notes.isEmpty { body["DeliveryNotes"] = notes }
        if let notes = returnPickupNotes, !notes.isEmpty { body["ReturnPickupNotes"] = notes }
        return body
    }
}
