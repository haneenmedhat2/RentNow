//
//  ServerResponseKey.swift
//  App
//
//  Created by MGAbouarab on 22/12/2023.
//

import Foundation

enum ServerResponseKey: String, Decodable {
    case success
    case fail
    case error
    case unauthenticated = "unauthenticated"
    case unauthorized = "unauthorized"
    case needActive
    case exception
    case blocked
    case notVerifiedFromNafaz = "not_verfied_from_nafaz"
}
