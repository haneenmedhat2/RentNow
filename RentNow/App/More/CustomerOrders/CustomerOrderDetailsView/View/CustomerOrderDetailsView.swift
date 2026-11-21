//
//  CustomerOrderDetailsView.swift
//  RentNow
//

import SwiftUI

struct CustomerOrderDetailsView: View {
    @ObservedObject var viewModel: CustomerOrderDetailsViewModel

    var body: some View {
        ZStack {
            MainGradientView()
                .ignoresSafeArea()

            VStack(spacing: 0) {
                BaseView(
                    viewModel: viewModel,
                    showMainBackground: false,
                    disableScroll: false
                ) {
                    if let details = viewModel.details {
                        VStack(spacing: 16) {
                            // Order Card
                            if let userInfo = details.userInfo, let order = details.order {
                                UserCardView(
                                    providerInfo: userInfo,
                                    order: order,
                                    formattedDate: viewModel.formattedDate,
                                    title: "The Lessor".localized
                                )
                            }

                            // Car Info
                            if let data = details.advertisementInfo {
                                OrderDetailsCarInfoView(data: data)
                            }

                            // Order Info
                            if let data = details.orderInfo {
                                OrderDetailsInfoView(data: data)
                            }

                            // Delivery Info
                            if let data = details.deliveryInfo {
                                OrderDetailsDeliveryView(
                                    data: data,
                                    hasValidLocation: viewModel.hasValidCoordinates(
                                        latitude: data.deliveryLatitude,
                                        longitude: data.deliveryLongitude
                                    ),
                                    onLocationTap: {
                                        viewModel.openLocation(
                                            latitude: data.deliveryLatitude,
                                            longitude: data.deliveryLongitude,
                                            label: data.deliveryLocation ?? ""
                                        )
                                    }
                                )
                            }

                            // Return Pickup Info
                            if let data = details.returnPickupInfo {
                                OrderDetailsReturnPickupView(
                                    data: data,
                                    hasValidLocation: viewModel.hasValidCoordinates(
                                        latitude: data.returnPickupLatitude,
                                        longitude: data.returnPickupLongitude
                                    ),
                                    onLocationTap: {
                                        viewModel.openLocation(
                                            latitude: data.returnPickupLatitude,
                                            longitude: data.returnPickupLongitude,
                                            label: data.returnPickupLocation ?? ""
                                        )
                                    }
                                )
                            }

                            // Pricing Summary
                            if let data = details.paymentInfo {
                                OrderDetailsPricingSummaryView(data: data)
                            }

                            // Handover Odometer
                            if let handover = details.handoverData, let photo = handover.odometerPhoto {
                                OrderDetailsOdometerView(
                                    title: "Handover Data".localized,
                                    data: handover,
                                    onImageTap: {
                                        viewModel.mediaViewerManager.prefetchAndShowImage(photo)
                                    }
                                )
                            }

                            // Return Odometer
                            if let returnData = details.returnData, let photo = returnData.odometerPhoto {
                                OrderDetailsOdometerView(
                                    title: "Return Data".localized,
                                    data: returnData,
                                    onImageTap: {
                                        viewModel.mediaViewerManager.prefetchAndShowImage(photo)
                                    }
                                )
                            }

                            // Extra Kilometers
                            if let data = details.extraKilometersData, (data.extraKilometers ?? 0) > 0 {
                                OrderDetailsExtraKMView(data: data , onPaymentTap:  {}, isProvider : true)
                            }

                            // Rating
                            if let rate = details.rate {
                                OrderDetailsRatingCardView(rateData: rate)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, viewModel.showBottomButton ? 80 : 16)
                    }
                }

                // Bottom Button
                if viewModel.showBottomButton {
                    MainButton(
                        title: viewModel.bottomButtonTitle,
                        backgroundColor: Color(.main)
                    ) {
                        viewModel.handleBottomAction()
                    }
                    .padding(.bottom, 16)
                }
            }
        }
        .navigationTitle("Order Details".localized)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchOrderDetails()
        }
        .refreshable {
            await viewModel.refreshOrderDetails()
        }
        .mediaViewer(viewModel.mediaViewerManager)
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
