//
//  AddAdEndpoint.swift
//  RentNow
//
//  Created by Claude Code
//

import Foundation
import Alamofire

enum AddAdEndpoint {

    static func formData() -> Endpoint<BaseResponse<AddAdFormData>> {
        return .init(
            method: .get,
            path: "Advertisement/FormData",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func mainCategoryDetails(mainCategoryId: Int) -> Endpoint<BaseResponse<AddAdCategoryDetails>> {
        return .init(
            method: .get,
            path: "Advertisement/MainCategoryDetails/\(mainCategoryId)",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func create(
        mainCategoryId: Int,
        subCategoryId: Int,
        carModelId: Int,
        carName: String,
        fuelType: Int,
        carTypeId: Int,
        pricePerDay: Double,
        description: String,
        safetyInstructions: String?,
        cityId: Int,
        latitude: Double,
        longitude: Double,
        images: [UploadData],
        minKilometersUsage: String?,
        maxKilometersUsage: String?,
        extraKilometerPrice: String?,
        insuranceValue: String?,
        isDeliveryEnabled: Bool?,
        isReceiveEnabled: Bool?,
        additionalFeatureIds: [Int]
    ) -> Endpoint<BaseResponse<CreateAdResponse>> {
        var bodyParams: APIParameters = [
            "MainCategoryId": mainCategoryId,
            "SubCategoryId": subCategoryId,
            "CarModelId": carModelId,
            "CarName": carName,
            "FuelType": fuelType,
            "CarTypeId": carTypeId,
            "PricePerDay": pricePerDay,
            "Description": description,
            "CityId": cityId,
            "Latitude": latitude,
            "Longitude": longitude
        ]

        if let safetyInstructions = safetyInstructions, !safetyInstructions.isEmpty {
            bodyParams["SafetyInstructions"] = safetyInstructions
        }

        if let minKm = minKilometersUsage, !minKm.isEmpty {
            bodyParams["MinKilometersUsage"] = minKm
        }

        if let maxKm = maxKilometersUsage, !maxKm.isEmpty {
            bodyParams["MaxKilometersUsage"] = maxKm
        }

        if let extraKmPrice = extraKilometerPrice, !extraKmPrice.isEmpty {
            bodyParams["ExtraKilometerPrice"] = extraKmPrice
        }

        if let insurance = insuranceValue, !insurance.isEmpty {
            bodyParams["InsuranceValue"] = insurance
        }

        if let delivery = isDeliveryEnabled {
            bodyParams["IsDeliveryToRenterLocationEnabled"] = delivery
        }

        if let received = isReceiveEnabled {
            bodyParams["IsReceivedFromRenterLocationEnabled"] = received
        }


        for (index, featureId) in additionalFeatureIds.enumerated() {
            bodyParams["AdditionalFeatureIds[\(index)]"] = featureId
        }

        for index in 0..<images.count {
            bodyParams["Images[\(index)].IsMainImage"] = (index == 0)
        }

        return .init(
            method: .post,
            path: "Advertisement/Create",
            body: bodyParams,
            headerType: .authorized(token: UserDefaults.accessToken ?? ""),
            uploads: images,
            encoding: .formData
        )
    }
}
