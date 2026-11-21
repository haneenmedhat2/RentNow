//
//  AllRatingsEndpoint.swift
//  RentNow
//

import Foundation
import Alamofire

enum AllRatingsEndpoint {
    static func getAdRates(advertisementId: Int, pageNumber: Int, pageSize: Int = 10) -> Endpoint<BaseResponse<AllRatingsPagingData>> {
        return .init(
            method: .get,
            path: "Advertisement/AdRates/\(advertisementId)",
            queries: ["pageNumber": pageNumber, "pageSize": pageSize]
        )
    }
}
