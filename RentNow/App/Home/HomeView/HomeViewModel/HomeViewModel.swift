//
//  HomeViewModel.swift
//  RentNow
//
//  Created by Elshamy on 25/01/2026.
//

import Foundation
import Combine
import UIKit
import CoreLocation

@MainActor
class HomeViewModel: BaseViewModel {

    // MARK: - Published Properties
    @Published var userName: String = ""
    @Published var userAddress: String = ""
    @Published var userImage: UIImage? = nil
    @Published var userImageUrl: String = ""
    @Published var categories: [CategoryItem] = []
    @Published var sliders: [ImageData] = []
    @Published var userInfo: UserInfoModel?

    // MARK: - Private Properties
    private let locationManager = CLLocationManager()
    private var locationCompletion: ((Double?, Double?) -> Void)?

    // MARK: - Init
    override init(responseHandler: ResponseHandler = DefaultResponseHandler()) {
        super.init(responseHandler: responseHandler)
        loadUserData()
        setupNotificationObserver()
    }

    @MainActor
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Notification Observer
    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("RefreshHomeData"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.loadUserData()
        }
    }

    // MARK: - Data Loading
    private func loadUserData() {
        if let user = UserDefaults.user {
            userName = user.fullName ?? "Default_Welcome_Title".localized
            let airportName = UserDefaults.selectedAirportName
            userAddress = airportName.isEmpty ? (user.mapDesc ?? "home_select_location".localized) : airportName
            userImageUrl = user.profilePicture ?? ""
        } else if UserDefaults.isVisitor {
            userName = "Default_Welcome_Title".localized
            userAddress = "home_select_location".localized
        }
    }

    // MARK: - API Calls
    func fetchHomeData() async {
        showIndicator()
        let endpoint = HomeEndpoint.getHomeDetails()
        do {
            let response = try await request(endpoint)

            guard let data = response else {
                hideIndicator()
                return
            }

            // Update sliders (convert to ImageData)
            sliders = data.sliders.toImageData()

            // Update categories (convert to CategoryItem)
            categories = data.mainCategories.map { category in
                CategoryItem(
                    id: category.id,
                    name: category.name,
                    image: nil,
                    imageUrl: category.imageUrl
                )
            }

            // Update user info if available
            if let userInfo = data.userInfo {
                self.userInfo = userInfo
                userName = userInfo.name ?? userName
                if let imageUrl = userInfo.imageUrl, !imageUrl.isEmpty {
                    userImageUrl = imageUrl
                }
            }

        } catch {
            showError(error.localizedDescription)
        }
        hideIndicator()
    }

    // MARK: - Actions
    func refreshData() {
        Task {
            await fetchHomeData()
        }
    }

    // MARK: - Location
    func getCurrentLocation(completion: @escaping (Double?, Double?) -> Void) {
        self.locationCompletion = completion

        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        let status = locationManager.authorizationStatus

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.attemptLocationFetch()
            }

        case .restricted, .denied:
            showError("location_permission_denied".localized)
            completion(nil, nil)

        case .authorizedAlways, .authorizedWhenInUse:
            attemptLocationFetch()

        @unknown default:
            completion(nil, nil)
        }
    }

    private func attemptLocationFetch() {
        if let location = locationManager.location {
            locationCompletion?(location.coordinate.latitude, location.coordinate.longitude)
        } else {
            locationManager.startUpdatingLocation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                guard let self = self else { return }
                if let location = self.locationManager.location {
                    self.locationCompletion?(location.coordinate.latitude, location.coordinate.longitude)
                } else {
                    self.locationCompletion?(nil, nil)
                }
                self.locationManager.stopUpdatingLocation()
            }
        }
    }
}

