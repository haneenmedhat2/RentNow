//
//  OrderDetailsView.swift
//  RentNow
//

import SwiftUI

struct OrderDetailsView: View {
    let coordinator: OrdersCoordinatorProtocol
    @ObservedObject var viewModel: OrderDetailsViewModel

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
                            if let providerInfo = details.providerInfo, let order = details.order {
                                OrderDetailsOrderCardView(
                                    providerInfo: providerInfo,
                                    order: order,
                                    formattedDate: viewModel.formattedDate
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
                                OrderDetailsPaymentStatusView(data: data) {
                                    guard viewModel.details?.paymentInfo?.canChangePaymentMethod == true else { return }
                                    coordinator.showChangePaymentMethod(
                                        orderId: viewModel.orderId,
                                        currentMethodId: viewModel.details?.paymentInfo?.paymentMethodId,
                                        totalPrice: data.finalTotal ?? data.total,
                                        onSaved: viewModel.applyPaymentMethodChange
                                    )
                                }
                                OrderDetailsPricingSummaryView(data: data)
                                if data.paymentProvider == .tabby || data.paymentMethodId == 4,
                                   details.buttonActions?.isPayment == true,
                                   !viewModel.isCancelAction,
                                   let total = data.finalTotal ?? data.total {
                                    TabbyInstallmentView(
                                        amount: total,
                                        currency: data.currency ?? "SAR",
                                        style: .checkout
                                    )
                                }
                                if data.paymentProvider == .tamara || data.paymentMethodId == 2,
                                   details.buttonActions?.isPayment == true,
                                   !viewModel.isCancelAction,
                                   let total = data.finalTotal ?? data.total {
                                    TamaraInstallmentView(
                                        amount: total,
                                        currency: data.currency ?? "SAR",
                                        style: .checkout
                                    )
                                }
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
                                OrderDetailsExtraKMView(data: data) {
                                    viewModel.paymentConfirmAction = { [weak viewModel] in viewModel?.payExceededKilometers() }
                                    viewModel.fetchExtraKMPaymentMethods()
                                }
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
                        backgroundColor: viewModel.isCancelAction ? .red : Color(.main)
                    ) {
                     
                            viewModel.handleBottomAction(coordinator: coordinator)
                        
                    }
                    .padding(.bottom, 16)
                    .disabled(viewModel.isStartingPayment)
                }
            }
        }
        .navigationTitle("Order Details".localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.details?.order?.status == 5 {
                    Button {
                        coordinator.showCreateReport(orderId: viewModel.orderId)
                    } label: {
                        Text("Report Incident".localized)
                            .expoSystemFont(size: FontSize.small, weight: .medium)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .task {
            await viewModel.fetchOrderDetails()
        }
        .refreshable {
            await viewModel.refreshOrderDetails()
        }
        .onChange(of: viewModel.paymentMethods.count) { newValue in
            if newValue > 0 {
                coordinator.showExtraKMPaymentSheet(
                    paymentMethods: viewModel.paymentMethods,
                    selectedValue: viewModel.selectedPaymentMethod
                ) { selected, moyasarMethod in
                    viewModel.selectedPaymentMethod = selected
                    viewModel.extraKilometersMoyasarMethod = moyasarMethod
                    viewModel.payExceededKilometers()
                }
                viewModel.paymentMethods = []
            }
        }
        .successPopup(message: "Payment Successful".localized, isPresented: $viewModel.showExtraKMSuccess)
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
