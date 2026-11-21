//
//  RequestHeader.swift
//  App
//
//  Created by MGAbouarab on 22/12/2023.
//

import Foundation

enum RequestHeaderType {
    
    case authorized(token: String)
    case unauthorized
    
    var header: [String:String] {
        
        var commonHeaders = [
            "accept": "application/json",
            "Content-Type": "application/json",
            "Accept-Language": Language.apiLanguage()
        ]
        
        switch self {
        case .authorized(let token):
            commonHeaders["Authorization"] = "Bearer \(token)"
            return commonHeaders
        case .unauthorized:
            return commonHeaders
        }
        
    }
    
}
