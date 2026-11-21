//
//  LocationPickerView.swift
//  Holool
//
//  Created by Elshamy on 23/11/2025.
//

import SwiftUI
import GoogleMaps

struct LocationPickerView: View {
    
    @ObservedObject var viewModel: LocationPickerViewModel
    var onSelect: ((_ selectedCoordinate: CLLocationCoordinate2D? ,_ currentAddress:String) -> Void)?       // Called when location is confirmed
    var isUserLocation:Bool = false
    var body: some View {
        BaseView(
            viewModel: viewModel,
            showMainBackground: false
        ) {
            ZStack {
                // MARK: - Google Map View
                GoogleMapView(
                    selectedCoordinate: $viewModel.selectedCoordinate,
                    onCameraIdle: { coordinate in
                        viewModel.updateSelectedLocation(coordinate)
                    }
                )
                
                // MARK: - Center Pin
                VStack {
                    Spacer()
                    Image("location-01")
                       .expoSystemFont(size: 40)
                        .foregroundStyle(LinearGradient.mainGradientVertical)
                    Spacer()
                }
                
                // MARK: - Bottom Sheet
                VStack {
                    Spacer()
                    LocationBottomSheetView(
                        currentAddress: viewModel.currentAddress,
                        onConfirmTapped: {
                            if isUserLocation {
                                viewModel.confirmLocation()

                            }else {
                                onSelect?(viewModel.selectedCoordinate, viewModel.currentAddress ?? "")
                            }
                        }
                    )
                }
            }
            .onChange(of: viewModel.successMessage) { message in
             
                onSelect?(viewModel.selectedCoordinate, viewModel.currentAddress ?? "")
                
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Choose location".localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            viewModel.requestCurrentLocation()
            // Force hide tab bar via UIKit (backup for SwiftUI timing issues)
            DispatchQueue.main.async {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let tabBar = windowScene.windows.first?.rootViewController?.view.subviews.first(where: { $0 is UITabBar }) as? UITabBar {
                    tabBar.isHidden = true
                }
            }
        }
        .onDisappear {
            // Restore tab bar
            DispatchQueue.main.async {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let tabBar = windowScene.windows.first?.rootViewController?.view.subviews.first(where: { $0 is UITabBar }) as? UITabBar {
                    tabBar.isHidden = false
                }
            }
        }
    }
}
