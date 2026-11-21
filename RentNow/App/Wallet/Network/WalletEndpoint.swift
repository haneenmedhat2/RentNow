//
//  WalletEndpoint.swift
//  RentNow
//
//  Created by Claude on 2026-02-08.
//

import Foundation
import Alamofire

enum WalletEndpoint {

    static func getMyActiveSubscription() -> Endpoint<BaseResponse<ActiveSubscription>> {
        return .init(
            method: .get,
            path: "Packages/GetMyActiveSubscription",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func getActivePackages() -> Endpoint<BaseResponse<[PackageItem]>> {
        return .init(
            method: .get,
            path: "Packages/GetActivePackages",
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func subscribe(packageId: Int, paymentMethod: Int = 1) -> Endpoint<BaseResponse<SubscribeResponse>> {
        return .init(
            method: .post,
            path: "Packages/Subscribe",
            queries: ["checkout": "sdk"],
            body: ["packageId": packageId, "paymentMethod": paymentMethod],
            headerType: .authorized(token: UserDefaults.accessToken ?? "")
        )
    }

    static func cancelSubscription(subscriptionId: Int) -> Endpoint<BaseResponse<Bool>> {
        return .init(
            method: .post,
            path: "Packages/CancelMySubscription",
            body: ["subscriptionId": subscriptionId],
            headerType: .authorized(token: UserDefaults.accessToken ?? ""),
            encoding: .formData
        )
    }
}
