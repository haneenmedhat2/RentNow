//
//  Double.swift
//  App
//
//  Created by MGAbouarab on 26/01/2024.
//

import Foundation

extension Double {
    var toPrice: String {
        return String(format: "%.2f", self).replacingOccurrences(of: ".00", with: "") + " " + "App_Currency".localized
    }
}
extension Double {
   

    func toStringData() -> String {
        return String(format: "%.01f", self)
    }
    
    func toPrecetage() -> String {
        return String(format: "%.01f", self) + " " + "%"
    }
    
    func toCoordinate() -> String {
        return String(format: "%.08f", self)
    }
}
