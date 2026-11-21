//
//  IntroEndpoint.swift
//  RentNow
//
//  Created by Claude on 22/01/2026.
//

import Foundation
import Alamofire

struct IntroEndpoint {

    static func getActiveSplashScreens() -> Endpoint<BaseResponse<[SplashScreenModel]>> {
        return .init(
            method: .get,
            path: "Lookups/GetActiveSplashScreens"
        )
    }
}
