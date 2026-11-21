//
//  CreateOrderView.swift
//  RentNow
//

import SwiftUI
import UIKit

struct CreateOrderView: View {
    let coordinator: HomeCoordinatorProtocol
    @ObservedObject var viewModel: CreateOrderViewModel
    @State private var isPaymentSheetExpanded = true

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollViewReader { scrollProxy in
                    BaseView(viewModel: viewModel, showMainBackground: false) {
                        VStack(spacing: 16) {

                            // MARK: - Car Info Card
                            if let ad = viewModel.pageData?.adDetails {
                                CreateOrderCarInfoCardView(
                                    imageUrl: ad.mainImage ?? "",
                                    carName: ad.name ?? "",
                                    cityName: ad.city ?? "",
                                    address: viewModel.deliveryMethod == .delivery
                                        ? (viewModel.deliveryAddress ?? ad.geoAddress ?? "")
                                        : (ad.geoAddress ?? "")
                                )
                            }

                            if let summary = viewModel.paymentSummary {
                                CreateOrderPaymentSummaryView(paymentSummary: summary)
                            }

                            // MARK: - Info Section
                            CreateOrderInfoSectionView(
                                rentalPolicy: viewModel.pageData?.rentalPolicy
                            )

                            // MARK: - Rental Start Date
                            AppDatePickerField(
                                title: "Rental start date".localized,
                                image: "calendar-02",
                                placeHolder: "Select rental start date".localized,
                                mode: .date,
                                text: $viewModel.dateFrom,
                                textError: $viewModel.dateFromError
                            )
                            .onChange(of: viewModel.dateFrom) { _ in
                                viewModel.updateDaysFromDates()
                                viewModel.checkAndFetchSummary()
                            }

                            // MARK: - Rental End Date
                            AppDatePickerField(
                                title: "Rental end date".localized,
                                image: "calendar-02",
                                placeHolder: "Select rental end date".localized,
                                mode: .date,
                                text: $viewModel.dateTo,
                                textError: $viewModel.dateToError
                            )
                            .onChange(of: viewModel.dateTo) { _ in
                                viewModel.updateDaysFromDates()
                                viewModel.checkAndFetchSummary()
                            }

                            // MARK: - Rental Start Time
                            AppDatePickerField(
                                title: "Rental start time".localized,
                                image: "time-04",
                                placeHolder: "Select time".localized,
                                mode: .time,
                                text: $viewModel.startTime,
                                textError: $viewModel.startTimeError
                            )
                            .onChange(of: viewModel.startTime) { _ in
                                viewModel.checkAndFetchSummary()
                            }

                            // MARK: - Number of Days
                            AppTextView(
                                title: "Number of days".localized,
                                image: "",
                                placeHolder: "Number of days".localized,
                                keyboardType: .numberPad,
                                isEditable: false,
                                text: $viewModel.numberOfDays,
                                textError: $viewModel.numberOfDaysError
                            )

                            // MARK: - Additional Features
                            if let features = viewModel.pageData?.additionalFeatures, !features.isEmpty {
                                CreateOrderAdditionalFeaturesSectionView(
                                    features: features,
                                    selectedFeatureIds: viewModel.selectedAdditionalFeatureIds,
                                    onToggleFeature: { viewModel.toggleAdditionalFeature($0) }
                                )
                            }

                            // MARK: - Delivery Method
                            if viewModel.isDeliveryEnabled {
                                CreateOrderDeliveryMethodView(
                                    deliveryMethod: $viewModel.deliveryMethod,
                                    isDeliveryEnabled: viewModel.isDeliveryEnabled,
                                    deliveryAddress: viewModel.deliveryAddress,
                                    error: viewModel.deliveryLocationError,
                                    onSelectLocation: {
                                        viewModel.getCurrentLocation { latitude, longitude in
                                            coordinator.showDeliveryAirportsSheet(
                                                latitude: latitude,
                                                longitude: longitude,
                                                onAirportSelected: { airportId, lat, lng, address in
                                                    viewModel.deliveryAirportId = airportId
                                                    viewModel.deliveryLatitude = lat
                                                    viewModel.deliveryLongitude = lng
                                                    viewModel.deliveryAddress = address
                                                    viewModel.checkAndFetchSummary()
                                                }
                                            )
                                        }
                                    }
                                )
                                .onChange(of: viewModel.deliveryMethod) { _ in
                                    viewModel.checkAndFetchSummary()
                                }
                            }

                            // MARK: - Delivery Notes
                            if viewModel.deliveryMethod == .delivery {
                                AppTextEditor(
                                    title: "Delivery notes".localized,
                                    placeHolder: "Enter your notes here".localized,
                                    text: $viewModel.deliveryNotes,
                                    textError: .constant(nil)
                                )
                            }

                            // MARK: - Return Pickup Method
                            if viewModel.isReturnPickupEnabled {
                                CreateOrderReturnPickupMethodView(
                                    returnPickupMethod: $viewModel.returnPickupMethod,
                                    returnPickupAddress: viewModel.returnPickupAddress,
                                    error: viewModel.returnPickupLocationError,
                                    onSelectLocation: {
                                        viewModel.getCurrentLocation { latitude, longitude in
                                            coordinator.showReturnPickupAirportsSheet(
                                                latitude: latitude,
                                                longitude: longitude,
                                                onAirportSelected: { airportId, lat, lng, address in
                                                    viewModel.returnPickupAirportId = airportId
                                                    viewModel.returnPickupLatitude = lat
                                                    viewModel.returnPickupLongitude = lng
                                                    viewModel.returnPickupAddress = address
                                                    viewModel.checkAndFetchSummary()
                                                }
                                            )
                                        }
                                    }
                                )
                                .onChange(of: viewModel.returnPickupMethod) { _ in
                                    viewModel.checkAndFetchSummary()
                                }
                            }

                            // MARK: - Return Pickup Notes
                            if viewModel.returnPickupMethod == .delivery {
                                AppTextEditor(
                                    title: "Return notes".localized,
                                    placeHolder: "Enter your notes here".localized,
                                    text: $viewModel.returnPickupNotes,
                                    textError: .constant(nil)
                                )
                            }
                            // MARK: - Terms Agreement
                            CreateOrderTermsSectionView(
                                agreedToTerms: viewModel.agreedToTerms,
                                cancellationAndDelayTerms: viewModel.pageData?.cancellationAndDelayTerms,
                                termsError: viewModel.termsError,
                                onToggleTerms: {
                                    viewModel.agreedToTerms.toggle()
                                    if viewModel.agreedToTerms { viewModel.termsError = nil }
                                },
                                onTermsTap: { coordinator.showCancellationTerms() }
                            )
                            .id("orderTerms")
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 16)
                    }
                    .onChange(of: viewModel.termsError) { _, error in
                        guard error != nil else { return }
                        withAnimation {
                            isPaymentSheetExpanded = false
                            scrollProxy.scrollTo("orderTerms", anchor: .bottom)
                        }
                    }
                }

                CreateOrderPaymentSheetView(
                    viewModel: viewModel,
                    isExpanded: $isPaymentSheetExpanded,
                    maximumHeight: geometry.size.height * 0.55
                )
            }
        }
        .background { MainGradientView().ignoresSafeArea() }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Book Car".localized)
        .task {
            await viewModel.fetchPageData()
        }
        .onDisappear { viewModel.stopCheckingPaymentOptions() }
        .onChange(of: viewModel.showSuccessPopup) { newValue in
            if newValue {
                coordinator.showOrderSuccess(orderId: viewModel.createdOrderId ?? 0)
            }
        }
        .onChange(of: viewModel.selectedAdditionalFeatureIds) { _ in
            viewModel.checkAndFetchSummary()
        }
        .onChange(of: viewModel.deliveryNotes) { _, _ in
            viewModel.checkAndFetchSummary()
        }
        .onChange(of: viewModel.returnPickupNotes) { _, _ in
            viewModel.checkAndFetchSummary()
        }
    }

}
