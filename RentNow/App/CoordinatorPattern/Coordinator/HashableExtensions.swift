//
//  HashableExtensions.swift
//  RentNow
//
//  Created by Elshamy on 21/01/2026.
//

import CoreLocation

// MARK: - CLLocationCoordinate2D Hashable Conformance
extension CLLocationCoordinate2D: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }

    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
