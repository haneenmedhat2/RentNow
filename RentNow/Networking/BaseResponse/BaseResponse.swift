//
//  BaseResponse.swift
//  App
//
//  Created by MGAbouarab on 22/12/2023.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    var key: ServerResponseKey
    var message: String
    var messageKey: String?
    var data: T?
    var isSuccess: Bool?
    var statusCode: Int?
    var traceId: String?

    enum CodingKeys: String, CodingKey {
        case key
        case message
        case messageKey
        case data
        case isSuccess, statusCode, traceId
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(ServerResponseKey.self, forKey: .key)
        message = try container.decodeIfPresent(String.self, forKey: .message) ?? ""
        messageKey = try container.decodeIfPresent(String.self, forKey: .messageKey)
        data = try container.decodeIfPresent(T.self, forKey: .data)
        isSuccess = try container.decodeIfPresent(Bool.self, forKey: .isSuccess)
        statusCode = try container.decodeIfPresent(Int.self, forKey: .statusCode)
        traceId = try container.decodeIfPresent(String.self, forKey: .traceId)
    }
}
