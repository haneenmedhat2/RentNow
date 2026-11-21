//
//  AirportModel.swift
//  RentNow
//
//  Created by Claude Code
//

import Foundation

struct Airport: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let deliveryCost: Double
    let cityId: Int
    let cityName: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case deliveryCost
        case cityId
        case cityName
    }
}

struct LocationCoordinate: Codable {
    let latitude: Double
    let longitude: Double
}
