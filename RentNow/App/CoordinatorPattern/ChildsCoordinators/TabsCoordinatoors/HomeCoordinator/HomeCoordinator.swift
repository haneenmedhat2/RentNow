//
//  HomeCoordinator.swift
//  RentNow
//
//  Created by Elshamy on 25/01/2026.
//

import SwiftUI
import CoreLocation
internal import _LocationEssentials

// MARK: - Home Routes
enum HomeRoute: Hashable {
    case home
    case carDetails(carId: Int)
    case categoryList(categoryId: Int, categoryName: String)
    case search
    case notifications
    case locationPicker
    case allRatings(advertisementId: Int)
    case providerProfile(providerId: String, providerName: String, providerImage: String)
    case createOrder(advertisementId: Int)
    case cancellationTerms
    case deliveryLocationPicker
    case returnPickupLocationPicker
    // Notification-tap destinations (hosted on Home stack so Back returns to NotificationsView)
    case orderDetails(orderId: Int)
    case customerOrderDetails(orderId: Int)
    case createReport(orderId: Int)
    case reportLocationPicker
}

// MARK: - Home Coordinator Protocol
protocol HomeCoordinatorProtocol {
    func showCarDetails(carId: Int)
    func showCategoryList(categoryId: Int, categoryName: String)
    func showSearch()
    func showNotifications()
    func showAirportsSheet(latitude: Double?, longitude: Double?)
    func showLocationPicker()
    func showFilterSheet(
        mainCategoryId: Int?,
        searchQuery: String?,
        existingParams: FilterParams?,
        onApply: @escaping (FilterParams) -> Void
    )
    func showAllRatings(advertisementId: Int)
    func showProviderProfile(providerId: String, providerName: String, providerImage: String)
    func showCreateOrder(advertisementId: Int)
    func showDeliveryAirportsSheet(latitude: Double?, longitude: Double?, onAirportSelected: @escaping (Int?, Double, Double, String) -> Void)
    func showReturnPickupAirportsSheet(latitude: Double?, longitude: Double?, onAirportSelected: @escaping (Int?, Double, Double, String) -> Void)
    func showCancellationTerms()
    func showOrderSuccess(orderId: Int)
    func openOrderDetailsFromNotification(orderId: Int)
    func openCustomerOrderDetailsFromNotification(orderId: Int)
    func openMyAdDetailsFromNotification(adId: Int, filterType: MyAdFilterType)
    func popToRoot()
    func closeView()
}

// MARK: - Home Coordinator
@MainActor
final class HomeCoordinator: BaseCoordinator<HomeRoute>, HomeCoordinatorProtocol, OrdersCoordinatorProtocol {
    var onOrderCreated: ((Int) -> Void)?
    var onLogout: (() -> Void)?
    private var deliveryAirportCallback: ((Int?, Double, Double, String) -> Void)?
    private var returnPickupAirportCallback: ((Int?, Double, Double, String) -> Void)?
    private var reportLocationCallback: ((CLLocationCoordinate2D?, String) -> Void)?
    private lazy var viewModel = HomeViewModel()

    override init() {
        super.init()
    }

    // MARK: - View Builder
    @ViewBuilder
    func buildHomeFlow() -> some View {
        NavigationStack(path: bindingPath) {
            makeView(for: .home)
                .navigationDestination(for: HomeRoute.self) { route in
                    self.makeView(for: route)
                }
        }
        .withCoordinatorPresentation(self)
    }

    @ViewBuilder
    private func makeView(for route: HomeRoute) -> some View {
        switch route {
        case .home:
            HomeView(coordinator: self, viewModel: viewModel)

        case .carDetails(let carId):
            AdvertisementDetailsView(
                coordinator: self,
                viewModel: AdvertisementDetailsViewModel(advertisementId: carId)
            )
            .toolbar(.hidden, for: .tabBar)

        case .categoryList(let categoryId, let categoryName):
            MainCategoryDetailsView(
                coordinator: self,
                viewModel: MainCategoryDetailsViewModel(
                    categoryId: categoryId,
                    categoryName: categoryName
                )
            )
            .toolbar(.hidden, for: .tabBar)

        case .search:
            SearchView(coordinator: self, viewModel: SearchViewModel())
                .toolbar(.hidden, for: .tabBar)

        case .notifications:
            NotificationsView(
                coordinator: self,
                viewModel: NotificationsViewModel()
            )
            .toolbar(.hidden, for: .tabBar)

        case .locationPicker:
            let pickerVM = LocationPickerViewModel()
            LocationPickerView(
                viewModel: pickerVM,
                onSelect: { [weak self] coordinate, address in
                    guard let self = self, let coordinate = coordinate else { return }
                    Task {
                        await self.applyUserLocationFromMap(
                            pickerVM: pickerVM,
                            coordinate: coordinate,
                            address: address,
                            onSuccess: { [weak self] in self?.pop() }
                        )
                    }
                }
            )
            .toolbar(.hidden, for: .tabBar)

        case .allRatings(let advertisementId):
            AllRatingsView(viewModel: AllRatingsViewModel(advertisementId: advertisementId))
                .toolbar(.hidden, for: .tabBar)

        case .providerProfile(let providerId, let providerName, let providerImage):
            ProviderProfileView(
                coordinator: self,
                viewModel: ProviderProfileViewModel(
                    providerId: providerId,
                    providerName: providerName,
                    providerImage: providerImage
                )
            )
            .toolbar(.hidden, for: .tabBar)

        case .createOrder(let advertisementId):
            CreateOrderView(
                coordinator: self,
                viewModel: CreateOrderViewModel(advertisementId: advertisementId)
            )
            .toolbar(.hidden, for: .tabBar)

        case .cancellationTerms:
            CancellationTermsView(viewModel: CancellationTermsViewModel())
                .toolbar(.hidden, for: .tabBar)

        case .deliveryLocationPicker:
            LocationPickerView(
                viewModel: LocationPickerViewModel(),
                onSelect: { [weak self] coordinate, address in
                    guard let coordinate = coordinate else { return }
                    self?.deliveryAirportCallback?(nil, coordinate.latitude, coordinate.longitude, address)
                    self?.pop()
                }
            )
            .toolbar(.hidden, for: .tabBar)

        case .returnPickupLocationPicker:
            LocationPickerView(
                viewModel: LocationPickerViewModel(),
                onSelect: { [weak self] coordinate, address in
                    guard let coordinate = coordinate else { return }
                    self?.returnPickupAirportCallback?(nil, coordinate.latitude, coordinate.longitude, address)
                    self?.pop()
                }
            )
            .toolbar(.hidden, for: .tabBar)

        case .orderDetails(let orderId):
            OrderDetailsView(
                coordinator: self,
                viewModel: makeOrderDetailsViewModel(orderId: orderId)
            )
            .toolbar(.hidden, for: .tabBar)

        case .customerOrderDetails(let orderId):
            CustomerOrderDetailsView(
                viewModel: CustomerOrderDetailsViewModel(orderId: orderId)
            )
            .toolbar(.hidden, for: .tabBar)

        case .createReport(let orderId):
            CreateReportView(
                coordinator: self,
                viewModel: makeCreateReportViewModel(orderId: orderId)
            )
            .toolbar(.hidden, for: .tabBar)

        case .reportLocationPicker:
            LocationPickerView(
                viewModel: LocationPickerViewModel(),
                onSelect: { [weak self] coordinate, address in
                    self?.reportLocationCallback?(coordinate, address)
                    self?.pop()
                }
            )
            .toolbar(.hidden, for: .tabBar)
        }
    }

    // MARK: - HomeCoordinatorProtocol

    func showCarDetails(carId: Int) {
        push(.carDetails(carId: carId))
    }

    func showCategoryList(categoryId: Int, categoryName: String) {
        push(.categoryList(categoryId: categoryId, categoryName: categoryName))
    }

    func showSearch() {
        push(.search)
    }

    func showNotifications() {
        if UserDefaults.isVisitor {
            showLoginRequired()
            return
        }
        push(.notifications)
    }

    func closeView() {
        close()
    }

    // MARK: - Visitor Login Required
    private func showLoginRequired() {
        let alertView = LoginRequiredPopupView(
            onLogin: { [weak self] in
                self?.dismiss()
                self?.onLogout?()
            },
            onCancel: { [weak self] in
                self?.dismiss()
            }
        )
        presentAsPopup(alertView)
    }

    // MARK: - AirportsSheet Presentation

    func showAirportsSheet(latitude: Double? = nil, longitude: Double? = nil) {
        if UserDefaults.isVisitor {
            showLoginRequired()
            return
        }
        let viewModel = AirportsSheetViewModel()

        // If coordinates provided, use them; otherwise get current location
        if let lat = latitude, let lng = longitude {
            Task {
                await viewModel.fetchNearbyAirports(latitude: lat, longitude: lng)
            }
        } else {
            viewModel.getCurrentLocation { [weak self] coordinate in
                guard let coordinate = coordinate else { return }
                Task {
                    await viewModel.fetchNearbyAirports(
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude
                    )
                }
            }
        }

        let sheetView = AirportsSheetView(
            viewModel: viewModel,
            onDismiss: { [weak self] in
                self?.dismiss()
            },
            onConfirm: { [weak self] in
                Task {
                    guard let airport = viewModel.selectedAirport else {
                        viewModel.showError("airport_selection_required".localized)
                        return
                    }

                    let success = await viewModel.setUserLocation(airportId: airport.id)

                    if success {
                        UserDefaults.selectedAirportName = airport.name
                        self?.dismiss()
                        NotificationCenter.default.post(
                            name: NSNotification.Name("RefreshHomeData"),
                            object: nil
                        )
                    }
                }
            },
            onOpenMapPicker: { [weak self] in
                self?.dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.showLocationPickerAsFullScreen()
                }
            }
        )

        presentAsSheet(sheetView, detentHeight: 500)
    }

    // MARK: - Apply User Location From Map (Home Path B)

    @MainActor
    private func applyUserLocationFromMap(
        pickerVM: LocationPickerViewModel,
        coordinate: CLLocationCoordinate2D,
        address: String,
        onSuccess: @escaping () -> Void
    ) async {
        let setUserLocationVM = AirportsSheetViewModel()
        pickerVM.showIndicator()
        let success = await setUserLocationVM.setUserLocation(
            airportId: nil,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        pickerVM.hideIndicator()

        if success {
            UserDefaults.selectedAirportName = ""
            if var user = UserDefaults.user {
                user.mapDesc = address
                UserDefaults.user = user
            }
            onSuccess()
            NotificationCenter.default.post(
                name: NSNotification.Name("RefreshHomeData"),
                object: nil
            )
        } else {
            pickerVM.showError("location_update_failed".localized)
        }
    }

    // MARK: - Delivery AirportsSheet Presentation

    func showDeliveryAirportsSheet(latitude: Double?, longitude: Double?, onAirportSelected: @escaping (Int?, Double, Double, String) -> Void) {
        deliveryAirportCallback = onAirportSelected

        let viewModel = AirportsSheetViewModel()

        if let lat = latitude, let lng = longitude {
            Task {
                await viewModel.fetchNearbyAirports(latitude: lat, longitude: lng)
            }
        } else {
            viewModel.getCurrentLocation { [weak self] coordinate in
                guard let coordinate = coordinate else { return }
                Task {
                    await viewModel.fetchNearbyAirports(
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude
                    )
                }
            }
        }

        let sheetView = AirportsSheetView(
            viewModel: viewModel,
            onDismiss: { [weak self] in
                self?.dismiss()
            },
            onConfirm: { [weak self] in
                guard let airport = viewModel.selectedAirport else {
                    viewModel.showError("airport_selection_required".localized)
                    return
                }

                let airportLat = viewModel.currentLocation?.latitude ?? latitude ?? 0
                let airportLng = viewModel.currentLocation?.longitude ?? longitude ?? 0

                self?.dismiss()
                onAirportSelected(airport.id, airportLat, airportLng, airport.name)
            },
            onOpenMapPicker: { [weak self] in
                self?.dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    self?.push(.deliveryLocationPicker)
                }
            }
        )

        presentAsSheet(sheetView, detentHeight: 500)
    }

    // MARK: - Return Pickup AirportsSheet Presentation

    func showReturnPickupAirportsSheet(
        latitude: Double?,
        longitude: Double?,
        onAirportSelected: @escaping (Int?, Double, Double, String) -> Void
    ) {
        returnPickupAirportCallback = onAirportSelected

        let viewModel = AirportsSheetViewModel()

        if let lat = latitude, let lng = longitude {
            Task {
                await viewModel.fetchNearbyAirports(latitude: lat, longitude: lng)
            }
        } else {
            viewModel.getCurrentLocation { [weak self] coordinate in
                guard let coordinate = coordinate else { return }
                Task {
                    await viewModel.fetchNearbyAirports(
                        latitude: coordinate.latitude,
                        longitude: coordinate.longitude
                    )
                }
            }
        }

        let sheetView = AirportsSheetView(
            viewModel: viewModel,
            onDismiss: { [weak self] in
                self?.dismiss()
            },
            onConfirm: { [weak self] in
                guard let airport = viewModel.selectedAirport else {
                    viewModel.showError("airport_selection_required".localized)
                    return
                }

                let airportLat = viewModel.currentLocation?.latitude ?? latitude ?? 0
                let airportLng = viewModel.currentLocation?.longitude ?? longitude ?? 0

                self?.dismiss()
                onAirportSelected(airport.id, airportLat, airportLng, airport.name)
            },
            onOpenMapPicker: { [weak self] in
                self?.dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    self?.push(.returnPickupLocationPicker)
                }
            }
        )

        presentAsSheet(sheetView, detentHeight: 500)
    }

    // MARK: - LocationPicker Navigation

    func showLocationPicker() {
        push(.locationPicker)
    }

    private func showLocationPickerAsFullScreen() {
        let pickerVM = LocationPickerViewModel()
        weak var weakSelf = self

        let view = LocationPickerView(
            viewModel: pickerVM,
            onSelect: { coordinate, address in
                guard let coordinate = coordinate, let self = weakSelf else { return }
                Task {
                    await self.applyUserLocationFromMap(
                        pickerVM: pickerVM,
                        coordinate: coordinate,
                        address: address,
                        onSuccess: { weakSelf?.dismiss() }
                    )
                }
            }
        )
        .overlay(alignment: .topLeading) {
            Button(action: {
                weakSelf?.dismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 36, height: 36)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
            .padding(.top, 50)
            .padding(.leading, 16)
        }
        .ignoresSafeArea()
        presentFullScreen(view)
    }

    func showAllRatings(advertisementId: Int) {
        push(.allRatings(advertisementId: advertisementId))
    }

    func showProviderProfile(providerId: String, providerName: String, providerImage: String) {
        push(.providerProfile(providerId: providerId, providerName: providerName, providerImage: providerImage))
    }

    func showCancellationTerms() {
        push(.cancellationTerms)
    }

    func showCreateOrder(advertisementId: Int) {
        if UserDefaults.isVisitor { showLoginRequired(); return }
        push(.createOrder(advertisementId: advertisementId))
    }

    func showOrderSuccess(orderId: Int) {
        let successView = SuccessView(
            title: "Order placed successfully".localized,
            subtitle: "Please wait while we redirect you".localized
        ) { [weak self] in
            self?.dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self?.popToRoot()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self?.onOrderCreated?(orderId)
                }
            }
        }
        presentAsPopup(successView)
    }

    // MARK: - Filter Sheet Presentation

    func showFilterSheet(
        mainCategoryId: Int?,
        searchQuery: String?,
        existingParams: FilterParams?,
        onApply: @escaping (FilterParams) -> Void
    ) {
        let filterContainerView = FilterContainerView(
            mainCategoryId: mainCategoryId,
            searchQuery: searchQuery,
            existingParams: existingParams,
            onDismiss: { [weak self] in
                self?.dismiss()
            },
            onApply: { [weak self] params in
                self?.dismiss()
                onApply(params)
            }
        )

        presentFullScreen(filterContainerView)
    }

    // MARK: - Notification-tap destinations (HomeCoordinatorProtocol)

    func openOrderDetailsFromNotification(orderId: Int) {
        push(.orderDetails(orderId: orderId))
    }

    func openCustomerOrderDetailsFromNotification(orderId: Int) {
        push(.customerOrderDetails(orderId: orderId))
    }

    func openMyAdDetailsFromNotification(adId: Int, filterType: MyAdFilterType) {
        guard let tabBar = AppCoordinator.shared?.tabBarCoordinator else { return }
        tabBar.moreCoordinator.popToRoot()
        tabBar.selectedTab = .more
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            tabBar.moreCoordinator.showMyAdDetails(adId: adId, filterType: filterType)
        }
    }

    // MARK: - OrdersCoordinatorProtocol (for notification-hosted OrderDetailsView / CreateReportView)

    func showOrderDetails(orderId: Int) {
        push(.orderDetails(orderId: orderId))
    }

    func showPayment(
        session: PaymentSession,
        onResult: @escaping (PaymentResult) -> Void
    ) {
        presentPayment(session: session, onResult: onResult)
    }

    func captureOdometer(orderId: Int, onResult: @escaping (Data, Double) -> Void) {
        let cameraView = CameraHostView(
            onResult: { [weak self] photoData, reading in
                self?.dismiss()
                onResult(photoData, reading)
            },
            onCancel: { [weak self] in
                self?.dismiss()
            }
        )
        presentFullScreen(cameraView)
    }

    func showRatingSheet(onSubmit: @escaping (Int) -> Void) {
        let ratingView = OrderDetailsRatingSheetView(
            onSubmit: { [weak self] rating in
                self?.dismiss()
                onSubmit(rating)
            },
            onClose: { [weak self] in
                self?.dismiss()
            }
        )
        presentAsSheet(ratingView, detentHeight: 400)
    }

    func showExtraKMPaymentSheet(paymentMethods: [OrderPaymentMethod], selectedValue: String?, onConfirm: @escaping (String?, MoyasarPaymentMethod) -> Void) {
        let sheetView = OrderDetailsExtraKMPaymentSheetView(
            paymentMethods: paymentMethods,
            selectedValue: selectedValue,
            onConfirm: { [weak self] selected, moyasarMethod in
                self?.dismiss()
                onConfirm(selected, moyasarMethod)
            },
            onClose: { [weak self] in
                self?.dismiss()
            }
        )
        presentAsSheet(sheetView, detentHeight: 500)
    }

    func showLogin() {
        onLogout?()
    }

    func showCreateReport(orderId: Int) {
        push(.createReport(orderId: orderId))
    }

    func showReportLocationPicker(onSelect: @escaping (CLLocationCoordinate2D?, String) -> Void) {
        reportLocationCallback = onSelect
        push(.reportLocationPicker)
    }

    // MARK: - Order / Report ViewModel factories

    private func makeOrderDetailsViewModel(orderId: Int) -> OrderDetailsViewModel {
        let viewModel = OrderDetailsViewModel(orderId: orderId)
        viewModel.onPaymentRequested = { [weak self, weak viewModel] session in
            self?.showPayment(session: session) { result in
                viewModel?.handlePaymentResult(result, kind: session.kind)
            }
        }
        return viewModel
    }

    private func makeCreateReportViewModel(orderId: Int) -> CreateReportViewModel {
        let viewModel = CreateReportViewModel(orderId: orderId)
        viewModel.onSuccess = { [weak self] in
            let successView = SuccessView(
                title: "Report sent successfully".localized,
                subtitle: "Your report has been sent successfully".localized,
                onDismiss: { [weak self] in
                    self?.dismiss()
                    self?.pop()
                }
            )
            self?.presentAsPopup(successView)
        }
        return viewModel
    }

    // MARK: - Reverse Geocoding Helper
    private func reverseGeocodeLocation(latitude: Double, longitude: Double) async -> String? {
        await withCheckedContinuation { continuation in
            let location = CLLocation(latitude: latitude, longitude: longitude)
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
                if let placemark = placemarks?.first {
                    let components = [placemark.locality, placemark.subAdministrativeArea, placemark.administrativeArea].compactMap { $0 }
                    let address = components.joined(separator: ", ")
                    continuation.resume(returning: address.isEmpty ? placemark.name : address)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}

// MARK: - Placeholder View
struct PlaceholderView: View {
    let title: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "hammer.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
            Text("Coming Soon".localized)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .logViewAppearance(viewName: "PlaceholderView")
    }
}
