//
//  AdvertisementDetailsView.swift
//  RentNow
//

import SwiftUI

struct AdvertisementDetailsView: View {

    let coordinator: HomeCoordinatorProtocol
    @ObservedObject var viewModel: AdvertisementDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var hideToastWorkItem: DispatchWorkItem?

    var body: some View {
        ZStack {
            MainGradientView()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        if let details = viewModel.details {
                            if !viewModel.sliderImages.isEmpty {
                                AdvertisementDetailsImageSliderView(
                                    images: viewModel.sliderImages,
                                    onBack: { dismiss() }
                                )
                            }

                            AdvertisementDetailsTitleView(
                                mainCategoryName: details.mainCategoryName ?? "",
                                subCategoryName: details.subCategoryName ?? "",
                                carNameText: details.carName ?? "",
                                averageRating: details.averageRating
                            )

                            AdvertisementDetailsLocationView(
                                cityName: details.cityName ?? "",
                                geoAddress: details.geoAddress ?? "",
                                hasValidLocation: viewModel.hasValidLocation,
                                onLocationTap: { viewModel.openLocation() }
                            )

                            AdvertisementDetailsCarDetailsView(
                                fuelType: details.fuelType ?? "",
                                description: details.description ?? "",
                                safetyInstructions: details.safetyInstructions
                            )

                            if let provider = details.provider {
                                AdvertisementDetailsProviderView(
                                    provider: provider,
                                    onProviderTap: {
                                        coordinator.showProviderProfile(
                                            providerId: provider.providerId ?? "",
                                            providerName: provider.providerName ?? "",
                                            providerImage: provider.providerImage ?? ""
                                        )
                                    }
                                )
                            }

                            AdvertisementDetailsRatingsView(
                                rates: viewModel.ratesWithIds,
                                onMoreTap: { coordinator.showAllRatings(advertisementId: viewModel.advertisementId) }
                            )

                            if let relatedAds = details.relatedAds, !relatedAds.isEmpty {
                                AdvertisementDetailsSimilarAdsView(
                                    relatedAds: relatedAds,
                                    onCarTap: { carId in coordinator.showCarDetails(carId: carId) }
                                )
                            }
                        }
                    }
                    .padding(.bottom, 80)
                }
                .ignoresSafeArea(edges: .top)

                if let details = viewModel.details {
                    AdvertisementDetailsBottomBarView(
                        pricePerDay: details.pricePerDay ?? 0,
                        canBook: viewModel.canBook,
                        onBookTap: { coordinator.showCreateOrder(advertisementId: viewModel.advertisementId) }
                    )
                  

                }
            }
            .disabled(viewModel.isLoading)
            .blur(radius: viewModel.isLoading ? 2 : 0)

            if viewModel.isLoading {
                LoaderUIView()
            }

           
        }
        .ignoresSafeArea(edges: .bottom)
        .toolbar(.hidden, for: .navigationBar)
        .logViewAppearance()
        .task {
            await viewModel.fetchDetails()
        }
        .onChange(of: viewModel.shouldDismiss) { shouldDismiss in
            if shouldDismiss {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    dismiss()
                }
            }
        }
        .confirmationDialog(
            "Open_Location_With_title".localized,
            isPresented: $viewModel.showMapPickerDialog,
            titleVisibility: .visible
        ) {
            Button("Maps_Action_title".localized) { viewModel.openInAppleMaps() }
            Button("Google_Maps_Action_title".localized) { viewModel.openInGoogleMaps() }
            Button("Cancel_Action_title".localized, role: .cancel) {}
        }
    }
}
