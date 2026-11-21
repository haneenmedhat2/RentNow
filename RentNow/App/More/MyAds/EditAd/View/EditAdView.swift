//
//  EditAdView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct EditAdView: View {
    let coordinator: MoreCoordinatorProtocol
    @ObservedObject var viewModel: EditAdViewModel
    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true, disableScroll: true) {
            VStack(spacing: 16) {

                // MARK: - Existing Images + New Image Picker
                imagesSection

                // MARK: - Price Per Day
                AppTextView(
                    title: "Price Per Day".localized,
                    image: "",
                    placeHolder: "Enter price per day".localized,
                    keyboardType: .decimalPad,
                    text: $viewModel.pricePerDay,
                    textError: $viewModel.pricePerDayError
                )

                // MARK: - Insurance Price
                AppTextView(
                    title: "Insurance Price".localized,
                    image: "",
                    placeHolder: "Enter insurance price".localized,
                    keyboardType: .decimalPad,
                    text: $viewModel.insuranceValue,
                    textError: $viewModel.insuranceValueError
                )
                .disabled(!viewModel.isInsuranceValueEditable)
                .opacity(viewModel.isInsuranceValueEditable ? 1.0 : 0.6)

                // MARK: - Description
                AppTextEditor(
                    title: "Car Description".localized,
                    placeHolder: "Enter car description".localized,
                    maxCharacters: 500,
                    text: $viewModel.descriptionText,
                    textError: $viewModel.descriptionError
                )

                // MARK: - Safety Instructions
                AppTextEditor(
                    title: "add_ad.safety_instructions".localized,
                    placeHolder: "add_ad.enter_safety_instructions".localized,
                    maxCharacters: 500,
                    text: $viewModel.safetyInstructions,
                    textError: $viewModel.safetyInstructionsError
                )

                // MARK: - Kilometer Fields
                if viewModel.isKilometerLimitEnabled {
                    AppTextView(
                        title: "Minimum Kilometers".localized,
                        image: "",
                        placeHolder: "Minimum Kilometers".localized,
                        keyboardType: .numberPad,
                        text: $viewModel.minKilometersUsage,
                        textError: $viewModel.minKmError
                    )

                    AppTextView(
                        title: "Maximum Kilometers".localized,
                        image: "",
                        placeHolder: "Maximum Kilometers".localized,
                        keyboardType: .numberPad,
                        text: $viewModel.maxKilometersUsage,
                        textError: $viewModel.maxKmError
                    )
                }

                // MARK: - Extra Kilometer Price
                if viewModel.isExtraKilometerPriceEditable {
                    AppTextView(
                        title: "Extra Kilometer Price".localized,
                        image: "",
                        placeHolder: "Extra Kilometer Price".localized,
                        keyboardType: .decimalPad,
                        text: $viewModel.extraKilometerPrice,
                        textError: $viewModel.extraKmPriceError
                    )
                }

                // MARK: - Additional Features (Toggleable)
                if !viewModel.additionalFeatures.isEmpty {
                    additionalFeaturesSection
                }

                // MARK: - Delivery Toggle
                deliverySection

                // MARK: - Confirm Button
                MainButton(title: "Confirm Edits".localized) {
                    viewModel.editAd()
                }

                Color.clear.frame(height: 16)
            }
            .padding(.top, 8)
        }
        .navigationTitle("Edit Ad Data".localized)
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.isEdited) { _, isEdited in
            if isEdited {
                coordinator.popToMyAds()
            }
        }
    }

    // MARK: - Images Section

    private var imagesSection: some View {
        AppImagePickerView(
            title: "Car Image".localized,
            mediaType: .photoOnly,
            maxCount: viewModel.maxImageCount,
            mediaItems: $viewModel.mediaItems,
            mediaError: $viewModel.mediaError
        )
    }

    // MARK: - Additional Features Section (Toggleable)

    private var additionalFeaturesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Available Additional Services".localized)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.black)

            ForEach(viewModel.additionalFeatures.filter { $0.id != nil }, id: \.id) { feature in
                Button {
                    viewModel.toggleAdditionalFeature(feature.id!)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: viewModel.selectedAdditionalFeatureIds.contains(feature.id!) ? "checkmark.square.fill" : "square")
                            .foregroundColor(viewModel.selectedAdditionalFeatureIds.contains(feature.id!) ? .mainColor : .gray)
                            .font(.system(size: 22))

                        Text(feature.name ?? "")
                            .expoSystemFont(size: FontSize.normal, weight: .regular)
                            .foregroundColor(.black)

                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Delivery Section

    private var deliverySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose from the following methods".localized)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.black)

            // Delivery to renter
            Button {
                viewModel.isDeliveryEnabled = true
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: viewModel.isDeliveryEnabled ? "checkmark.square.fill" : "square")
                        .foregroundColor(viewModel.isDeliveryEnabled ? .mainColor : .gray)
                        .font(.system(size: 22))

                    Text("Delivery to Renter".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor(.black)

                    Spacer()
                }
            }

            // Pickup from owner
            Button {
                viewModel.isDeliveryEnabled = false
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: !viewModel.isDeliveryEnabled ? "checkmark.square.fill" : "square")
                        .foregroundColor(!viewModel.isDeliveryEnabled ? .mainColor : .gray)
                        .font(.system(size: 22))

                    Text("Pickup from Owner Location".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor(.black)

                    Spacer()
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
