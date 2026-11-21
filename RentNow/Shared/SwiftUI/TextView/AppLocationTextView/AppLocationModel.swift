//
//  AppLocationModel.swift
//  Holool
//
//  Created by Elshamy on 01/12/2025.
//

import CoreLocation

struct LocationData: Equatable {
    var address: String
    var coordinate: CLLocationCoordinate2D
    
    static func == (lhs: LocationData, rhs: LocationData) -> Bool {
        return lhs.address == rhs.address &&
               lhs.coordinate.latitude == rhs.coordinate.latitude &&
               lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}
