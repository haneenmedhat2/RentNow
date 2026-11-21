//
//  MyAdDetailsView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct MyAdDetailsView: View {

    let coordinator: MoreCoordinatorProtocol
    @ObservedObject var viewModel: MyAdDetailsViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            MainGradientView()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        if let details = viewModel.details {
                            // Image Slider with overlay buttons
                            if !viewModel.sliderImages.isEmpty {
                                ZStack {
                                    AdvertisementDetailsImageSliderView(
                                        images: viewModel.sliderImages,
                                        onBack: { dismiss() }
                                    )

                                    // Edit & Delete buttons overlay (underReview only)
                                    if viewModel.adStatus == .underReview {
                                        MyAdDetailsImageOverlayButtonsView(
                                            canEdit: details.canEdit == true,
                                            canDelete: details.canDelete == true,
                                            onEdit: { if let details = viewModel.details { coordinator.showEditAd(details: details) } },
                                            onDelete: {
                                                coordinator.showDeleteAdSheet {
                                                    Task { await viewModel.deleteAd() }
                                                }
                                            }
                                        )
                                    }
                                }
                                .frame(height: 300)
                            }

                            // Status Badge + Title Section
                            MyAdDetailsTitleSectionView(
                                statusText: details.statusText,
                                mainCategoryName: details.mainCategoryName ?? "",
                                subCategoryName: details.subCategoryName ?? "",
                                carName: details.carName ?? "",
                                pricePerDay: details.pricePerDay ?? 0
                            )

                            // Ad Status Toggle (Approved only)
                            if viewModel.adStatus == .approved {
                                MyAdDetailsStatusToggleView(
                                    isAvailable: viewModel.isAvailable,
                                    onToggle: {
                                        Task { await viewModel.toggleAvailability() }
                                    }
                                )
                            }

                            // Location
                            AdvertisementDetailsLocationView(
                                cityName: details.cityName ?? "",
                                geoAddress: details.geoAddress ?? "",
                                hasValidLocation: viewModel.hasValidLocation,
                                onLocationTap: { viewModel.openLocation() }
                            )

                            // Fuel Type & Description
                            AdvertisementDetailsCarDetailsView(
                                fuelType: details.fuelType ?? "",
                                description: details.description ?? "",
                                safetyInstructions: details.safetyInstructions
                            )

                            // Other Details (Insurance + Delivery)
                            MyAdDetailsOtherDetailsView(
                                insurancePrice: details.insurranceValue ?? 0,
                                isDeliveryToRenterLocationEnabled: details.isDeliveryToRenterLocationEnabled ?? false
                            )

                            // Additional Car Services (data-driven, all statuses)
                            if let features = details.additionalFeatures?.filter({ $0.isSelected == true }), !features.isEmpty {
                                MyAdDetailsAdditionalServicesView(features: features)
                            }

                            // Kilometer Details (data-driven, all statuses)
                            MyAdDetailsKilometerView(
                                minKm: details.minKilometersUsage ?? 0,
                                maxKm: details.maxKilometersUsage ?? 0,
                                extraKmPrice: details.extraKilometerPrice ?? 0
                            )

                            // Ratings (Approved only)
                            if viewModel.adStatus == .approved {
                                AdvertisementDetailsRatingsView(
                                    rates: details.latestRates ?? [],
                                    onMoreTap: { coordinator.showAllRatings(advertisementId: viewModel.adId) }
                                )
                            }

                            // Rejection Reason (Rejected only)
                            if viewModel.adStatus == .rejected,
                               let reason = details.rejectionReason, !reason.isEmpty {
                                MyAdDetailsRejectionReasonView(reason: reason)
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
                .ignoresSafeArea(edges: .top)

                // Edit Ad Button (Rejected only)
                if viewModel.adStatus == .rejected {
                    MainButton(title: "Edit Ad".localized) {
                        if let details = viewModel.details { coordinator.showEditAd(details: details) }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
            .disabled(viewModel.isLoading)
            .blur(radius: viewModel.isLoading ? 2 : 0)

            if viewModel.isLoading {
                LoaderUIView()
            }
        }
//        .ignoresSafeArea(edges: .bottom)
        .toolbar(.hidden, for: .navigationBar)
        .logViewAppearance()
        .task {
            await viewModel.fetchDetails()
        }
        .onChange(of: viewModel.isDeleted) { _, isDeleted in
            if isDeleted {
                dismiss()
            }
        }

    }
}
