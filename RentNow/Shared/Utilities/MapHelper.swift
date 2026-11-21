//
//  MapHelper.swift
//  Holool
//
//  Created by Elshamy on 23/12/2025.
//

import UIKit

struct MapHelper {

    /// Opens Apple Maps with the specified coordinates and label
    /// - Parameters:
    ///   - latitude: Latitude as String or Double
    ///   - longitude: Longitude as String or Double
    ///   - label: Optional label for the location (defaults to "الموقع")
    static func openLocation(latitude: String?, longitude: String?, label: String? = nil) {
        guard let lat = latitude, let lng = longitude,
              let latValue = Double(lat), let lngValue = Double(lng) else {
            print("❌ Invalid coordinates: lat=\(latitude ?? "nil"), lng=\(longitude ?? "nil")")
            return
        }

        openLocation(latitude: latValue, longitude: lngValue, label: label)
    }

    /// Opens Apple Maps with the specified coordinates and label
    /// - Parameters:
    ///   - latitude: Latitude as Double
    ///   - longitude: Longitude as Double
    ///   - label: Optional label for the location (defaults to "الموقع")
    static func openLocation(latitude: Double, longitude: Double, label: String? = nil) {
        let coordinate = "\(latitude),\(longitude)"
        let locationLabel = label ?? "الموقع"

        guard let encodedLabel = locationLabel.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "http://maps.apple.com/?ll=\(coordinate)&q=\(encodedLabel)") else {
            print("❌ Failed to create maps URL")
            return
        }

        print("🗺️ Opening maps for: \(locationLabel) at \(coordinate)")
        UIApplication.shared.open(url)
    }

    /// Opens Google Maps app if installed, otherwise the Google Maps web URL.
    static func openInGoogleMaps(latitude: Double, longitude: Double) {
        let coordinate = "\(latitude),\(longitude)"
        guard let appURL = URL(string: "comgooglemaps://?daddr=\(coordinate)&directionsmode=driving"),
              let webURL = URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(coordinate)") else {
            print("❌ Failed to create Google Maps URL")
            return
        }

        UIApplication.shared.open(appURL, options: [:]) { success in
            if !success {
                UIApplication.shared.open(webURL)
            }
        }
    }
}
