//
//  OrdersEndpoint.swift
//  RentNow
//
//  Created by Claude on 2026-02-09.
//

import Foundation
import Alamofire

enum OrdersEndpoint {
    static func getMyOrders(filter: String) -> Endpoint<BaseResponse<[OrderItem]>> {
        return .init(
            method: .get,
            path: "Order/GetMyOrders",
            queries: ["filter": filter],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func getOrderDetails(orderId: Int) -> Endpoint<BaseResponse<OrderDetailsData>> {
        return .init(
            method: .get,
            path: "Order/GetOrderDetails/\(orderId)",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func cancelOrder(orderId: Int) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .post,
            path: "Order/CancelOrder/\(orderId)",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func payOrder(orderId: Int) -> Endpoint<BaseResponse<PayOrderData>> {
        return .init(
            method: .post,
            path: "Order/PayOrder/\(orderId)",
            queries: ["checkout": "sdk"],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    /// Method IDs come from the backend options (1 Moyasar, 2 Tamara, 4 Tabby).
    static func changePaymentMethod(orderId: Int, paymentMethod: Int) -> Endpoint<BaseResponse<OrderDetailsData>> {
        .init(
            method: .put,
            path: "Order/ChangePaymentMethod/\(orderId)",
            body: ["paymentMethod": paymentMethod],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func confirmHandover(orderId: Int, odometerPhoto: Data, odometerReading: Double) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .post,
            path: "Order/ConfirmHandoverByCustomer/\(orderId)",
            body: ["OdometerReading": odometerReading],
            headerType: .authorized(token: UserDefaults.accessToken ?? ""),
            uploads: [UploadData(key: "OdometerPhoto", data: odometerPhoto, mimeType: .jpeg)],
            encoding: .formData
        )
    }

    static func rateOrder(orderId: Int, rating: Int) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .post,
            path: "Order/AddRateToOrder/\(orderId)",
            body: ["Rating": rating],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func payExceededKilometers(orderId: Int) -> Endpoint<BaseResponse<PayOrderData>> {
        return .init(
            method: .post,
            path: "Order/PayExceededKilometers/\(orderId)",
            queries: ["checkout": "sdk"],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func getPaymentMethods() -> Endpoint<BaseResponse<[OrderPaymentMethod]>> {
        return .init(
            method: .get,
            path: "Order/PaymentMethods",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func confirmReturn(orderId: Int, odometerPhoto: Data, odometerReading: Double) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .post,
            path: "Order/ConfirmReturnByCustomer/\(orderId)",
            body: ["OdometerReading": odometerReading],
            headerType: .authorized(token: UserDefaults.accessToken ?? ""),
            uploads: [UploadData(key: "OdometerPhoto", data: odometerPhoto, mimeType: .jpeg)],
            encoding: .formData
        )
    }

    static func reportIncident(
        orderId: Int,
        incidentDate: String,
        latitude: Double,
        longitude: Double,
        incidentReportIssuer: String,
        files: [UploadData]
    ) -> Endpoint<BaseResponse<Int>> {
        return .init(
            method: .post,
            path: "Order/ReportIncident/\(orderId)",
            body: [
                "IncidentDate": incidentDate,
                "Latitude": latitude,
                "Longitude": longitude,
                "IncidentReportIssuer": incidentReportIssuer
            ],
            headerType: .authorized(token: UserDefaults.accessToken ?? ""),
            uploads: files,
            encoding: .formData
        )
    }
}
