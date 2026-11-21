//
//  GoogleMapsRepresentable.swift
//  Holool
//
//  Created by Elshamy on 24/11/2025.
//

import GoogleMaps
import SwiftUI


// MARK: - Google Map UIViewRepresentable
struct GoogleMapsRepresentable: UIViewRepresentable {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    var onCameraIdle: ((CLLocationCoordinate2D) -> Void)?
    var onMyLocationTapped: ((CLLocationCoordinate2D) -> Void)?
    
    private let locationManager = LocationManager.shared
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = locationManager.createCameraPosition(for: selectedCoordinate)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        
        locationManager.configureMapView(mapView)
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        if let coordinate = selectedCoordinate {
            let currentCenter = mapView.camera.target
            
            if !locationManager.isSameLocation(coordinate, currentCenter) &&
               !context.coordinator.isUserInteracting {
                locationManager.moveToCoordinate(mapView, coordinate: coordinate)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapsRepresentable
        var isUserInteracting = false
        
        init(_ parent: GoogleMapsRepresentable) {
            self.parent = parent
        }
        
        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
            if gesture {
                isUserInteracting = true
            }
        }
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            isUserInteracting = false
            parent.onCameraIdle?(position.target)
        }
        
        func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
            parent.onMyLocationTapped?(location)
        }
        
        func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
            return false
        }
    }
}


// MARK: - Google Map View (Simplified)
struct GoogleMapView: UIViewRepresentable {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    var onCameraIdle: ((CLLocationCoordinate2D) -> Void)?
    var bottomPadding: CGFloat = 200
    
    private let locationManager = LocationManager.shared
    
    func makeUIView(context: Context) -> GMSMapView {
        let camera = locationManager.createCameraPosition(for: selectedCoordinate)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        
        locationManager.configureMapView(mapView, bottomPadding: bottomPadding)
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        if let coordinate = selectedCoordinate {
            let currentCenter = mapView.camera.target
            
            if !locationManager.isSameLocation(coordinate, currentCenter) &&
               !context.coordinator.isUserInteracting {
                locationManager.moveToCoordinate(mapView, coordinate: coordinate)
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GoogleMapView
        var isUserInteracting = false
        
        init(_ parent: GoogleMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
            if gesture {
                isUserInteracting = true
            }
        }
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            isUserInteracting = false
            parent.onCameraIdle?(position.target)
        }
        
        func mapView(_ mapView: GMSMapView, didTapMyLocation location: CLLocationCoordinate2D) {
            // Handle if needed
        }
    }
}
