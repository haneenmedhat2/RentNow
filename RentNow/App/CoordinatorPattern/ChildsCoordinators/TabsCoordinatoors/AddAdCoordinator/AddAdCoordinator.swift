//
//  AddAdCoordinator.swift
//  RentNow
//
//  Created by Elshamy on 25/01/2026.
//

import SwiftUI
import CoreLocation

// MARK: - AddAd Routes
enum AddAdRoute: Hashable {
    case addAd
    case locationPicker
}

// MARK: - AddAd Coordinator Protocol
protocol AddAdCoordinatorProtocol {
    func showLocationPicker()
    func closeAddAd()
    func showSuccessPopup()
    func showLogin()
}

// MARK: - AddAd Coordinator
@MainActor
final class AddAdCoordinator: BaseCoordinator<AddAdRoute>, AddAdCoordinatorProtocol {

    var onClose: (() -> Void)?
    var onAdCreated: ((Int) -> Void)?
    var onLogout: (() -> Void)?
    private lazy var viewModel = AddAdViewModel()

    override init() {
        super.init()
    }

    // MARK: - View Builder
    @ViewBuilder
    func buildAddAdFlow() -> some View {
        NavigationStack(path: bindingPath) {
            makeView(for: .addAd)
                .navigationDestination(for: AddAdRoute.self) { route in
                    self.makeView(for: route)
                }
        }
        .withCoordinatorPresentation(self)
    }

    @ViewBuilder
    private func makeView(for route: AddAdRoute) -> some View {
        switch route {
        case .addAd:
            AddAdView(coordinator: self, viewModel: viewModel)

        case .locationPicker:
            LocationPickerView(
                viewModel: LocationPickerViewModel(),
                onSelect: { [weak self] coordinate, address in
                    if let coordinate = coordinate {
                        self?.viewModel.setLocation(
                            latitude: coordinate.latitude,
                            longitude: coordinate.longitude,
                            address: address
                        )
                    }
                    self?.pop()
                }
            )
            .toolbar(.hidden, for: .tabBar)
        }
    }

    // MARK: - AddAdCoordinatorProtocol

    func showLocationPicker() {
        push(.locationPicker)
    }

    func closeAddAd() {
        onClose?()
    }

    func showSuccessPopup() {
        let adId = viewModel.createdAdId
        let successView = SuccessView(
            title: "add_ad.success_title".localized,
            subtitle: "add_ad.success_subtitle".localized
        ) {
            self.dismiss()
            self.resetForm()
            if let adId = adId {
                self.onAdCreated?(adId)
            } else {
                self.onClose?()
            }
        }
        presentAsPopup(successView)
    }

    func showLogin() {
        onLogout?()
    }

    // MARK: - Reset

    private func resetForm() {
        viewModel = AddAdViewModel()
    }
}
