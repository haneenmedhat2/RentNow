//
//  LocationPickerViewModel.swift
//  Holool
//
//  Created by Elshamy on 23/11/2025.
//

import Foundation
import CoreLocation
import Combine
class LocationPickerViewModel: BaseViewModel {
    
    @Published var selectedCoordinate: CLLocationCoordinate2D?
    @Published var currentAddress: String?
    @Published var locationConfirmed: Bool = false

    private let locationManager = LocationManager.shared
    private var initialCoordinate: CLLocationCoordinate2D?
    private var isInitialLoad = true
    
    override init(responseHandler: any ResponseHandler = DefaultResponseHandler()) {
        super.init(responseHandler: responseHandler)
        setupLocationObserver()
    }
    
    init(
        initialCoordinate: CLLocationCoordinate2D? = nil,
        responseHandler: any ResponseHandler = DefaultResponseHandler()
    ) {
        self.initialCoordinate = initialCoordinate
        super.init(responseHandler: responseHandler)
        setupLocationObserver()
        applyInitialCoordinateIfNeeded()
    }

    private func setupLocationObserver() {
        locationManager.$currentLocation
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                self?.updateCurrentLocation(location)
            }
            .store(in: &cancellables)
        
        locationManager.$currentAddress
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] address in
                guard let self else { return }
                let isSameLocation = self.locationManager.isSameLocation(
                    self.selectedCoordinate,
                    self.locationManager.currentCoordinate
                )
                if self.isInitialLoad || isSameLocation {
                    self.currentAddress = address
                }
            }
            .store(in: &cancellables)
    }
    
    private func applyInitialCoordinateIfNeeded() {
        if let coordinate = initialCoordinate {
            selectedCoordinate = coordinate
            
            locationManager.fetchAddress(for: coordinate) { [weak self] address in
                self?.currentAddress = address
            }
            
            isInitialLoad = false
        } else {
            requestCurrentLocation()
        }
    }
    
    func requestCurrentLocation() {
        locationManager.requestCurrentLocation()
    }
    
    func updateSelectedLocation(_ coordinate: CLLocationCoordinate2D) {
        guard !isInitialLoad else {
            isInitialLoad = false
            return
        }
        
        selectedCoordinate = coordinate
        
        locationManager.fetchAddress(for: coordinate) { [weak self] address in
            self?.currentAddress = address ?? "Unable to get address".localized
        }
    }
    
    @MainActor
    func confirmLocation() {
        guard let coordinate = selectedCoordinate ?? locationManager.currentCoordinate else {
            return
        }
        
        submitLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            address: currentAddress ?? ""
        )
    }
    
    private func updateCurrentLocation(_ location: CLLocation) {
        selectedCoordinate = location.coordinate
    }
    
    @MainActor
    private func submitLocation(latitude: Double, longitude: Double, address: String) {
//        Task {
//            showIndicator()
//            
//            let endPoint = HomeEndpoint.chooseLocation(
//                lat: String(latitude),
//                lng: String(longitude),
//                address: address
//            )
//            
//            do {
//                let response = try await requestFullResponse(endPoint)
//                guard response.data != nil else { return }
//                
//                UserDefaults.user = response.data
//                showSuccess(response.message)
//                
//                successMessage = response.message
//                
//            } catch {
//                showError(error.localizedDescription)
//            }
//            
//            hideIndicator()
//        }
    }
}
