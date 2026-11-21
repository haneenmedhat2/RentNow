//
//  ResponseError.swift
//  App
//
//  Created by MGAbouarab on 22/12/2023.
//

import Foundation

enum ResponseError: Error {
    case canNotConnectToServer
    case serverError
    case unableToDecodeResponse
    case emptyResponse
    case server(message: String)
}

extension ResponseError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .canNotConnectToServer:
            return "Can not send request, please check your connection"
        case .serverError:
            return "There is an error in our servers and we work on it, please try again later"
        case .unableToDecodeResponse:
            return "unexpected error happened and we will work on it, please try again later"
        case .emptyResponse:
            return "Server returned empty response. Please try again or contact support."
        case .server(let message):
            return message
        }
    }
}

