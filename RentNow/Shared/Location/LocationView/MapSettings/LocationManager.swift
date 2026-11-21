//
//  LocationManager.swift
//  Holool
//
//  Created by Elshamy on 23/11/2025.
//

import Foundation
import CoreLocation
import GoogleMaps
import UIKit
import Combine

// MARK: - Location Manager
/// A unified manager that handles all location-related operations with Google Maps
final class LocationManager: NSObject, ObservableObject {
    
    // MARK: - Singleton
    static let shared = LocationManager()
    
    // MARK: - Published Properties
    @Published private(set) var currentLocation: CLLocation?
    @Published private(set) var currentAddress: String?
    @Published private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published private(set) var isLoading = false
    @Published private(set) var error: LocationError?
    
    // MARK: - Private Properties
    private let manager = CLLocationManager()
    private let geocoder = GMSGeocoder()
    private var geocodingWorkItem: DispatchWorkItem?
    
    // MARK: - Constants
    static let defaultLatitude: Double = 24.7136
    static let defaultLongitude: Double = 46.6753
    static let defaultZoom: Float = 15.0
    
    // MARK: - Computed Properties
    var hasLocationPermission: Bool {
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }
    
    var currentCoordinate: CLLocationCoordinate2D? {
        currentLocation?.coordinate
    }
    
    // MARK: - Initialization
    private override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatus = manager.authorizationStatus
    }
    
    // MARK: - Location Methods
    
    /// Request current location from GPS
    func requestCurrentLocation() {
        error = nil
        
        switch authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            isLoading = true
            manager.requestLocation()
        case .denied, .restricted:
            error = .permissionDenied
        @unknown default:
            break
        }
    }
    
    /// Start continuous location updates
    func startUpdatingLocation() {
        guard hasLocationPermission else {
            requestCurrentLocation()
            return
        }
        manager.startUpdatingLocation()
    }
    
    /// Stop continuous location updates
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
    /// Request location permission only
    func requestPermission() {
        if authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: - Geocoding Methods
    
    /// Get address from coordinates with debounce
    func fetchAddress(
        for coordinate: CLLocationCoordinate2D,
        debounceInterval: TimeInterval = 0.8,
        completion: ((String?) -> Void)? = nil
    ) {
        geocodingWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.reverseGeocode(coordinate: coordinate) { address in
                DispatchQueue.main.async {
                    self?.currentAddress = address
                    completion?(address)
                }
            }
        }
        
        geocodingWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceInterval, execute: workItem)
    }
    
    /// Get address immediately without debounce
    func fetchAddressImmediately(
        for coordinate: CLLocationCoordinate2D,
        completion: @escaping (String?) -> Void
    ) {
        reverseGeocode(coordinate: coordinate, completion: completion)
    }
    
    // MARK: - Map Configuration
    
    /// Configure map view with standard settings
    func configureMapView(_ mapView: GMSMapView, bottomPadding: CGFloat = 0) {
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.settings.zoomGestures = true
        mapView.settings.scrollGestures = true
        mapView.settings.rotateGestures = true
        mapView.settings.tiltGestures = true
        
        if bottomPadding > 0 {
            mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: bottomPadding, right: 16)
        }
    }
    
    /// Create camera position for coordinate
    func createCameraPosition(
        for coordinate: CLLocationCoordinate2D? = nil,
        zoom: Float? = nil
    ) -> GMSCameraPosition {
        GMSCameraPosition.camera(
            withLatitude: coordinate?.latitude ?? Self.defaultLatitude,
            longitude: coordinate?.longitude ?? Self.defaultLongitude,
            zoom: zoom ?? Self.defaultZoom
        )
    }
    
    /// Apply custom map style from JSON
    func applyMapStyle(_ mapView: GMSMapView, jsonString: String) {
        do {
            mapView.mapStyle = try GMSMapStyle(jsonString: jsonString)
        } catch {
            print("Failed to apply map style: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Map Overlays
    
    /// Create a marker
    func createMarker(
        at coordinate: CLLocationCoordinate2D,
        title: String? = nil,
        snippet: String? = nil,
        icon: UIImage? = nil
    ) -> GMSMarker {
        let marker = GMSMarker(position: coordinate)
        marker.title = title
        marker.snippet = snippet
        marker.icon = icon
        return marker
    }
    
    /// Create a circle overlay
    func createCircle(
        at coordinate: CLLocationCoordinate2D,
        radius: CLLocationDistance,
        fillColor: UIColor = UIColor.blue.withAlphaComponent(0.2),
        strokeColor: UIColor = .blue,
        strokeWidth: CGFloat = 2
    ) -> GMSCircle {
        let circle = GMSCircle(position: coordinate, radius: radius)
        circle.fillColor = fillColor
        circle.strokeColor = strokeColor
        circle.strokeWidth = strokeWidth
        return circle
    }
    
    /// Create a polyline from coordinates
    func createPolyline(
        from coordinates: [CLLocationCoordinate2D],
        strokeColor: UIColor = .blue,
        strokeWidth: CGFloat = 3
    ) -> GMSPolyline {
        let path = GMSMutablePath()
        coordinates.forEach { path.add($0) }
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeColor = strokeColor
        polyline.strokeWidth = strokeWidth
        return polyline
    }
    
    // MARK: - Camera & Bounds
    
    /// Get bounds containing all coordinates
    func getBounds(for coordinates: [CLLocationCoordinate2D]) -> GMSCoordinateBounds? {
        guard !coordinates.isEmpty else { return nil }
        
        var bounds = GMSCoordinateBounds()
        coordinates.forEach { bounds = bounds.includingCoordinate($0) }
        return bounds
    }
    
    /// Animate map to fit all coordinates
    func fitMapToCoordinates(
        _ mapView: GMSMapView,
        coordinates: [CLLocationCoordinate2D],
        padding: CGFloat = 50,
        animated: Bool = true
    ) {
        guard let bounds = getBounds(for: coordinates) else { return }
        let update = GMSCameraUpdate.fit(bounds, withPadding: padding)
        
        if animated {
            mapView.animate(with: update)
        } else {
            mapView.moveCamera(update)
        }
    }
    
    /// Move map to coordinate
    func moveToCoordinate(
        _ mapView: GMSMapView,
        coordinate: CLLocationCoordinate2D,
        zoom: Float? = nil,
        animated: Bool = true
    ) {
        let camera = GMSCameraPosition.camera(
            withTarget: coordinate,
            zoom: zoom ?? mapView.camera.zoom
        )
        
        if animated {
            mapView.animate(to: camera)
        } else {
            mapView.camera = camera
        }
    }
    
    // MARK: - Distance & Comparison
    
    /// Calculate distance between two coordinates in meters
    func distance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let fromLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let toLocation = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return fromLocation.distance(from: toLocation)
    }
    
    /// Check if two coordinates are approximately the same
    func isSameLocation(
        _ coord1: CLLocationCoordinate2D?,
        _ coord2: CLLocationCoordinate2D?,
        threshold: Double = 0.0001
    ) -> Bool {
        guard let c1 = coord1, let c2 = coord2 else { return false }
        return abs(c1.latitude - c2.latitude) < threshold &&
               abs(c1.longitude - c2.longitude) < threshold
    }
    
    // MARK: - Navigation
    
    /// Open location in Maps app
    func openInMaps(latitude: Double, longitude: Double) {
        // Try Google Maps
        if let url = URL(string: "comgooglemaps://?daddr=\(latitude),\(longitude)&directionsmode=driving"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            return
        }
        
        // Try Apple Maps
        if let url = URL(string: "maps://?daddr=\(latitude),\(longitude)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
            return
        }
        
        // Fallback to web
        if let url = URL(string: "https://www.google.com/maps/dir/?daddr=\(latitude),\(longitude)") {
            UIApplication.shared.open(url)
        }
    }
    
    /// Open location with current location as source
    func openDirections(to coordinate: CLLocationCoordinate2D) {
        openInMaps(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    /// Open app settings
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
    
    // MARK: - Private Methods
    
    private func reverseGeocode(
        coordinate: CLLocationCoordinate2D,
        completion: @escaping (String?) -> Void
    ) {
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            if error != nil {
                completion(nil)
                return
            }
            
            guard let result = response?.firstResult() else {
                completion(nil)
                return
            }
            
            // Build address
            let components = [
                result.thoroughfare,
                result.locality,
                result.administrativeArea,
                result.country
            ].compactMap { $0 }
            
            let address = components.isEmpty ? result.lines?.first : components.joined(separator: ", ")
            completion(address)
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async {
            self.currentLocation = location
            self.isLoading = false
            
            // Auto-fetch address
            self.fetchAddressImmediately(for: location.coordinate) { [weak self] address in
                DispatchQueue.main.async {
                    self?.currentAddress = address
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.error = .locationUnavailable
            self.isLoading = false
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
            self.authorizationStatus = manager.authorizationStatus
            
            if self.hasLocationPermission {
                self.isLoading = true
                manager.requestLocation()
            }
        }
    }
}

// MARK: - Location Errors
enum LocationError: LocalizedError {
    case permissionDenied
    case locationUnavailable
    case geocodingFailed
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "Location permission denied. Please enable in Settings.".localized
        case .locationUnavailable:
            return "Unable to get current location.".localized
        case .geocodingFailed:
            return "Unable to get address for this location.".localized
        }
    }
}

// MARK: - Coordinate Extension
extension CLLocationCoordinate2D {
    var isValid: Bool {
        CLLocationCoordinate2DIsValid(self)
    }
    
    static var defaultCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: LocationManager.defaultLatitude,
            longitude: LocationManager.defaultLongitude
        )
    }
}
