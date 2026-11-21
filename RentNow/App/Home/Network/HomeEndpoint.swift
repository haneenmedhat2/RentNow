//
//  HomeEndpoint.swift
//  RentNow
//
//  Created by Claude on 2026-01-27.
//

import Foundation
import Alamofire

enum HomeEndpoint {
    static func getHomeDetails() -> Endpoint<BaseResponse<HomeDetailsData>> {
        if let token = UserDefaults.accessToken, !token.isEmpty {
            return .init(
                method: .get,
                path: "Home/HomeDetails",
                headerType: .authorized(token: token)
            )
        }
        return .init(
            method: .get,
            path: "Home/HomeDetails"
        )
    }

    // MARK: - Notifications Endpoints

    static func getNotifications() -> Endpoint<BaseResponse<[NotificationItem]>> {
        return .init(
            method: .get,
            path: "Home/ListOfNotifyClient",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func deleteAllNotifications() -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .delete,
            path: "Home/DeleteAllNotify",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func deleteNotification(id notificationId: Int) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .delete,
            path: "Home/DeleteNotify",
            queries: ["id": notificationId],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    // MARK: - Location & Airports Endpoints

    static func getNearbyAirports(latitude: Double, longitude: Double) -> Endpoint<BaseResponse<[Airport]>> {
        return .init(
            method: .post,
            path: "Home/GetNearbyAirports",
            body: [
                "latitude": latitude,
                "longitude": longitude
            ],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func setUserLocation(latitude: Double, longitude: Double, airportId: Int?) -> Endpoint<BaseResponse<Bool>> {
        var body: APIParameters = [
            "latitude": latitude,
            "longitude": longitude
        ]
        if let airportId = airportId {
            body["deliveryAirportId"] = airportId
        }
        return .init(
            method: .post,
            path: "Home/SetUserLocation",
            body: body,
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }
    
    static func search(
        mainCategoryId: Int?,
        subCategoryId: Int? = nil,
        carTypeIds: [Int]? = nil,
        fuelTypes: [Int]? = nil,
        cityIds: [Int]? = nil,
        additionalFeatureIds: [Int]? = nil,
        minPrice: Double? = nil,
        maxPrice: Double? = nil,
        carName: String? = nil
    ) -> Endpoint<BaseResponse<MainCategoryDetailsData>> {

        var bodyParams: APIParameters = [:]
        if let mainCategoryId = mainCategoryId {
            bodyParams["mainCategoryId"] = mainCategoryId
        }
        if let subCategoryId = subCategoryId {
            bodyParams["subCategoryId"] = subCategoryId


        }

        if let carTypeIds = carTypeIds, !carTypeIds.isEmpty {
            bodyParams["carTypeIds"] = carTypeIds
        }

        if let fuelTypes = fuelTypes, !fuelTypes.isEmpty {
            bodyParams["fuelTypes"] = fuelTypes
        }

        if let cityIds = cityIds, !cityIds.isEmpty {
            bodyParams["cityIds"] = cityIds
        }

        if let additionalFeatureIds = additionalFeatureIds, !additionalFeatureIds.isEmpty {
            bodyParams["additionalFeatureIds"] = additionalFeatureIds
        }

        if let minPrice = minPrice {
            bodyParams["minPrice"] = minPrice
        }

        if let maxPrice = maxPrice {
            bodyParams["maxPrice"] = maxPrice
        }

        if let carName = carName, !carName.isEmpty {
            bodyParams["carName"] = carName
        }

        return .init(
            method: .post,
            path: "Home/Search",
            body: bodyParams,
            headerType:  UserDefaults.accessToken != nil ? .authorized(token: UserDefaults.accessToken ?? "") : .unauthorized

        
        )
    }

    // MARK: - Owner Advertisements Endpoint

    static func getOwnerAdvertisements(providerId: String) -> Endpoint<BaseResponse<OwnerAdvertisementsData>> {
        return .init(
            method: .get,
            path: "Advertisement/OwnerAdvertisements/\(providerId)"
        )
    }

    // MARK: - Advertisement Details Endpoint

    static func getAdvertisementDetails(id: Int) -> Endpoint<BaseResponse<AdvertisementDetailsData>> {
        return .init(
            method: .get,
            path: "Advertisement/Details/\(id)"            
        )
    }

    // MARK: - Filter Data Endpoint

    static func filterData(
        mainCategoryId: Int?,
        searchQuery: String?
    ) -> Endpoint<BaseResponse<FilterDataResponse>> {
        var bodyParams: APIParameters = [:]

        if let mainCategoryId = mainCategoryId {
            bodyParams["MainCategoryId"] = mainCategoryId
        }

        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            bodyParams["SearchQuery"] = searchQuery
        }

        return .init(
            method: .get,
            path: "Home/FilterData",
            queries: bodyParams
        )
    }
    
    
    
    static func getOrderPageData(advertisementId: Int) -> Endpoint<BaseResponse<OrderPageData>> {
        return .init(
            method: .get,
            path: "Order/GetOrderPageData/\(advertisementId)",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func getOrderPaymentSummary(request: OrderBookingRequest) -> Endpoint<BaseResponse<OrderPaymentSummary>> {
        .init(
            method: .post,
            path: "Order/OrderPaymentSummary",
            body: request.parameters,
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func getCancellationTerms() -> Endpoint<BaseResponse<CancellationTermsData>> {
        return .init(
            method: .get,
            path: "More/ConditionsForCancellationAndDelay",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func createOrder(request: OrderBookingRequest) -> Endpoint<BaseResponse<CreateOrderResponse>> {
        .init(
            method: .post,
            path: "Order/CreateOrder",
            body: request.parameters,
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }
}
