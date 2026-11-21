//
//  AirportsSheetViewModel.swift
//  RentNow
//
//  Created by Claude Code
//

import Foundation
import CoreLocation
import Combine

@MainActor
final class AirportsSheetViewModel: BaseViewModel {
    // MARK: - Published Properties
    @Published var airports: [Airport] = []
    @Published var selectedAirport: Airport?
    @Published var currentLocation: LocationCoordinate?
    @Published var currentAddress: String = ""
    @Published var isEmpty: Bool = false

    // MARK: - Private Properties
    private let locationManager = CLLocationManager()
    private var locationCompletion: ((LocationCoordinate?) -> Void)?

    // MARK: - Initialization
    override init(responseHandler: ResponseHandler = DefaultResponseHandler()) {
        super.init(responseHandler: responseHandler)
        setupLocationManager()
    }

    // MARK: - Location Setup
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: - Public Methods

    /// Get user's current GPS location
    func getCurrentLocation(completion: @escaping (LocationCoordinate?) -> Void) {
        self.locationCompletion = completion

        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            // Wait for user decision
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.attemptLocationFetch()
            }

        case .restricted, .denied:
            showError("location_permission_denied".localized)
            completion(nil)

        case .authorizedAlways, .authorizedWhenInUse:
            attemptLocationFetch()

        @unknown default:
            completion(nil)
        }
    }

    private func attemptLocationFetch() {
        if let location = locationManager.location {
            let coordinate = LocationCoordinate(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            currentLocation = coordinate
            locationCompletion?(coordinate)
        } else {
            locationManager.startUpdatingLocation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                guard let self = self else { return }
                if let location = self.locationManager.location {
                    let coordinate = LocationCoordinate(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude
                    )
                    self.currentLocation = coordinate
                    self.locationCompletion?(coordinate)
                } else {
                    self.locationCompletion?(nil)
                }
                self.locationManager.stopUpdatingLocation()
            }
        }
    }

    /// Reverse geocode coordinates to address
    private func reverseGeocode(latitude: Double, longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location) { [weak self] placemarks, _ in
            if let placemark = placemarks?.first {
                let components = [placemark.locality, placemark.subAdministrativeArea, placemark.administrativeArea].compactMap { $0 }
                let address = components.joined(separator: ", ")
                DispatchQueue.main.async {
                    self?.currentAddress = address.isEmpty ? (placemark.name ?? "") : address
                }
            }
        }
    }

    /// Fetch nearby airports from API
    func fetchNearbyAirports(latitude: Double, longitude: Double) async {
        currentLocation = LocationCoordinate(latitude: latitude, longitude: longitude)
        reverseGeocode(latitude: latitude, longitude: longitude)

        showIndicator()
        let endpoint = HomeEndpoint.getNearbyAirports(latitude: latitude, longitude: longitude)

        do {
            let response = try await request(endpoint)

            airports = response ?? []
            isEmpty = airports.isEmpty

            // Auto-select first airport if available
            if !airports.isEmpty {
                selectedAirport = airports.first
            }

        } catch {
            showError(error.localizedDescription)
            isEmpty = true
        }

        hideIndicator()
    }

    /// Update user's location. `airportId` is optional — pass nil for map-only selection.
    /// Optional explicit `latitude`/`longitude` override `currentLocation` (used when called as a service from another flow).
    func setUserLocation(
        airportId: Int?,
        latitude: Double? = nil,
        longitude: Double? = nil
    ) async -> Bool {
        let lat: Double
        let lng: Double
        if let latitude = latitude, let longitude = longitude {
            lat = latitude
            lng = longitude
        } else if let location = currentLocation {
            lat = location.latitude
            lng = location.longitude
        } else {
            showError("location_not_available".localized)
            return false
        }

        showIndicator()
        let endpoint = HomeEndpoint.setUserLocation(
            latitude: lat,
            longitude: lng,
            airportId: airportId
        )

        do {
            _ = try await request(endpoint)
            showSuccess("location_updated_successfully".localized)
            hideIndicator()
            return true
        } catch {
            showError(error.localizedDescription)
            hideIndicator()
            return false
        }
    }

    /// Select an airport from the list
    func selectAirport(_ airport: Airport) {
        selectedAirport = airport
    }
}
