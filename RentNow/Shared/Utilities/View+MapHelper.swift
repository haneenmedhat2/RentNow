//
//  View+MapHelper.swift
//  Holool
//
//  Created by Elshamy on 23/12/2025.
//

import SwiftUI

extension View {
    /// Opens Apple Maps with the specified coordinates
    /// - Parameters:
    ///   - latitude: Latitude as String or Double
    ///   - longitude: Longitude as String or Double
    ///   - label: Optional label for the location
    func openMaps(latitude: String?, longitude: String?, label: String? = nil) {
        MapHelper.openLocation(latitude: latitude, longitude: longitude, label: label)
    }

    /// Opens Apple Maps with the specified coordinates
    /// - Parameters:
    ///   - latitude: Latitude as Double
    ///   - longitude: Longitude as Double
    ///   - label: Optional label for the location
    func openMaps(latitude: Double, longitude: Double, label: String? = nil) {
        MapHelper.openLocation(latitude: latitude, longitude: longitude, label: label)
    }
}
