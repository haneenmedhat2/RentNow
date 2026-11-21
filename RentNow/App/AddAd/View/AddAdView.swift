//
//  AddAdView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct AddAdView: View {
    let coordinator: AddAdCoordinatorProtocol
    @ObservedObject var viewModel: AddAdViewModel

    var body: some View {
        if UserDefaults.isVisitor {
            LoginRequiredView {
                coordinator.showLogin()
            }
        } else {
            addAdContent
        }
    }

    private var addAdContent: some View {
        BaseView(viewModel: viewModel, showMainBackground: true, disableScroll: true) {
            VStack(spacing: 16) {

                // MARK: - Image Picker
                AppImagePickerView(
                    title: "add_ad.car_image".localized,
                    mediaType: .photoOnly,
                    maxCount: 3,
                    mediaItems: $viewModel.mediaItems,
                    mediaError: $viewModel.mediaError
                )

                // MARK: - Car Type
                AppPickerField(
                    title: "add_ad.car_type".localized,
                    items: viewModel.carTypes,
                    selectedItem: $viewModel.selectedCarType,
                    errorMessage: viewModel.carTypeError
                )

                // MARK: - Car Model
                AppPickerField(
                    title: "add_ad.car_model".localized,
                    items: viewModel.carModels,
                    selectedItem: $viewModel.selectedCarModel,
                    errorMessage: viewModel.carModelError
                )

                // MARK: - Fuel Type
                AppPickerField(
                    title: "add_ad.fuel_type".localized,
                    items: viewModel.fuelTypes,
                    selectedItem: $viewModel.selectedFuelType,
                    errorMessage: viewModel.fuelTypeError
                )

                // MARK: - Main Category
                AppPickerField(
                    title: "add_ad.main_category".localized,
                    items: viewModel.mainCategories,
                    selectedItem: $viewModel.selectedMainCategory,
                    errorMessage: viewModel.mainCategoryError
                )

                // MARK: - Sub Category
                AppPickerField(
                    title: "add_ad.sub_category".localized,
                    items: viewModel.subCategories,
                    selectedItem: $viewModel.selectedSubCategory,
                    errorMessage: viewModel.subCategoryError
                )

                // MARK: - City
                AppPickerField(
                    title: "add_ad.city".localized,
                    items: viewModel.cities,
                    selectedItem: $viewModel.selectedCity,
                    errorMessage: viewModel.cityError
                )

                // MARK: - Location
                locationPickerRow

                // MARK: - Price Per Day
                AppTextView(
                    title: "add_ad.price_per_day".localized,
                    image: "",
                    placeHolder: "add_ad.enter_price".localized,
                    keyboardType: .decimalPad,
                    suffix: "SAR".localized,
                    text: $viewModel.pricePerDay,
                    textError: $viewModel.pricePerDayError
                )

                // MARK: - Insurance Price
                AppTextView(
                    title: "add_ad.insurance_price".localized,
                    image: "",
                    placeHolder: "add_ad.enter_insurance".localized,
                    keyboardType: .decimalPad,
                    suffix: "SAR".localized,
                    text: $viewModel.insuranceValue,
                    textError: $viewModel.insuranceValueError
                )
                .disabled(!viewModel.isInsuranceValueEditable)
                .opacity(viewModel.isInsuranceValueEditable ? 1.0 : 0.6)

                // MARK: - Conditional: Kilometer Fields
                if viewModel.isKilometerLimitEnabled {
                    AppTextView(
                        title: "add_ad.min_km".localized,
                        image: "",
                        placeHolder: "add_ad.min_km".localized,
                        keyboardType: .numberPad,
                        text: $viewModel.minKilometersUsage,
                        textError: $viewModel.minKmError
                    )

                    AppTextView(
                        title: "add_ad.max_km".localized,
                        image: "",
                        placeHolder: "add_ad.max_km".localized,
                        keyboardType: .numberPad,
                        text: $viewModel.maxKilometersUsage,
                        textError: $viewModel.maxKmError
                    )
                }

                // MARK: - Conditional: Extra Kilometer Price
                if viewModel.isExtraKilometerPriceEditable {
                    AppTextView(
                        title: "add_ad.extra_km_price".localized,
                        image: "",
                        placeHolder: "add_ad.extra_km_price".localized,
                        keyboardType: .decimalPad,
                        text: $viewModel.extraKilometerPrice,
                        textError: $viewModel.extraKmPriceError
                    )
                }

                // MARK: - Conditional: Delivery Toggle
                if viewModel.isDeliveryToRenterLocationEnabled {
                    deliveryToggleRow
                }

                // MARK: - Conditional: Receive Toggle
                if viewModel.isReceivedFromRenterLocationEnabled {
                    receiveToggleRow
                }

                // MARK: - Description
                AppTextEditor(
                    title: "add_ad.description".localized,
                    placeHolder: "add_ad.enter_description".localized,
                    maxCharacters: 500,
                    text: $viewModel.description,
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

                // MARK: - Additional Features
                if !viewModel.additionalFeatures.isEmpty {
                    additionalFeaturesSection
                }

                // MARK: - Confirm Button
                MainButton(title: "add_ad.confirm".localized) {
                    viewModel.createAdvertisement()
                }

                Color.clear.frame(height: 16)
            }
            .padding(.top, 8)
        }
        .navigationTitle("add_ad.title".localized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    coordinator.closeAddAd()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.text)
                }
            }
        }
        .task {
            viewModel.fetchFormData()
        }
        .onChange(of: viewModel.selectedMainCategory) { _ in
            viewModel.fetchCategoryDetails()
        }
        .onChange(of: viewModel.showSuccessPopup) { show in
            if show {
                coordinator.showSuccessPopup()
            }
        }
    }

    // MARK: - Location Picker Row

    private var locationPickerRow: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("add_ad.location".localized)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.black)

            VStack(spacing: 0) {
                Button {
                    coordinator.showLocationPicker()
                } label: {
                    HStack {
                        Text(viewModel.selectedAddress.isEmpty ? "add_ad.select_location".localized : viewModel.selectedAddress)
                            .expoSystemFont(size: FontSize.normal, weight: .regular)
                            .foregroundColor(viewModel.selectedAddress.isEmpty ? .placeholder : .black)
                            .lineLimit(1)

                        Spacer()

                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .glassyBackground(cornerRadius: 12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(
                        !viewModel.locationError.isEmpty ? Color.red : Color.clear,
                        lineWidth: 0.7
                    ))
                }

                if !viewModel.locationError.isEmpty {
                    HStack {
                        Text(viewModel.locationError)
                            .expoSystemFont(size: FontSize.small, weight: .medium)
                            .foregroundColor(.red)
                            .padding(8)
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Delivery Toggle Row

    private var deliveryToggleRow: some View {
        HStack {
            Text("add_ad.delivery_enabled".localized)
                .expoSystemFont(size: FontSize.normal, weight: .medium)

            Spacer()

            Toggle("", isOn: $viewModel.isDeliveryEnabled)
                .labelsHidden()
                .tint(.mainColor)
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Receive Toggle Row

    private var receiveToggleRow: some View {
        HStack {
            Text("add_ad.receive_enabled".localized)
                .expoSystemFont(size: FontSize.normal, weight: .medium)

            Spacer()

            Toggle("", isOn: $viewModel.isReceiveEnabled)
                .labelsHidden()
                .tint(.mainColor)
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Additional Features Section

    private var additionalFeaturesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("add_ad.additional_services".localized)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.black)

            ForEach(viewModel.additionalFeatures) { feature in
                Button {
                    viewModel.toggleAdditionalFeature(feature.id)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: viewModel.selectedAdditionalFeatureIds.contains(feature.id) ? "checkmark.square.fill" : "square")
                            .foregroundColor(viewModel.selectedAdditionalFeatureIds.contains(feature.id) ? .mainColor : .gray)
                            .font(.system(size: 22))

                        Text(feature.name)
                            .expoSystemFont(size: FontSize.normal, weight: .regular)
                            .foregroundColor(.black)

                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
