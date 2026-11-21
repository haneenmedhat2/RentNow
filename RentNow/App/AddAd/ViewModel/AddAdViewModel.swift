//
//  AddAdViewModel.swift
//  RentNow
//
//  Created by Claude Code
//

import Foundation
import SwiftUI
import Combine

@MainActor
class AddAdViewModel: BaseViewModel {

    // MARK: - Form Data Lists
    @Published var mainCategories: [AddAdMainCategory] = []
    @Published var carModels: [CarModel] = []
    @Published var carTypes: [AddAdCarType] = []
    @Published var cities: [FilterCity] = []
    @Published var fuelTypes: [FuelType] = []
    @Published var subCategories: [SubCategory] = []
    @Published var additionalFeatures: [AdditionalFeature] = []

    // MARK: - Config Flags
    @Published var isKilometerLimitEnabled: Bool = false
    @Published var isDeliveryToRenterLocationEnabled: Bool = false
    @Published var isReceivedFromRenterLocationEnabled: Bool = false
    @Published var isInsuranceValueEditable: Bool = true
    @Published var isExtraKilometerPriceEditable: Bool = false
    @Published var defaultExtraKilometerPrice: Double = 0.0

    // MARK: - Selected Values
    @Published var selectedCarType: AddAdCarType?
    @Published var selectedCarModel: CarModel?
    @Published var selectedFuelType: FuelType?
    @Published var selectedMainCategory: AddAdMainCategory?
    @Published var selectedSubCategory: SubCategory?
    @Published var selectedCity: FilterCity?
    @Published var selectedLatitude: Double?
    @Published var selectedLongitude: Double?
    @Published var selectedAddress: String = ""
    @Published var pricePerDay: String = ""
    @Published var insuranceValue: String = ""
    @Published var description: String = ""
    @Published var safetyInstructions: String = ""
    @Published var selectedAdditionalFeatureIds: Set<Int> = []
    @Published var mediaItems: [MediaItem] = []
    @Published var showSuccessPopup: Bool = false
    @Published var createdAdId: Int?

    // MARK: - Conditional Fields
    @Published var minKilometersUsage: String = ""
    @Published var maxKilometersUsage: String = ""
    @Published var extraKilometerPrice: String = ""
    @Published var isDeliveryEnabled: Bool = false
    @Published var isReceiveEnabled: Bool = false

    // MARK: - Error Strings
    @Published var mediaError: String?
    @Published var carTypeError: String = ""
    @Published var carModelError: String = ""
    @Published var fuelTypeError: String = ""
    @Published var mainCategoryError: String = ""
    @Published var subCategoryError: String = ""
    @Published var cityError: String = ""
    @Published var locationError: String = ""
    @Published var pricePerDayError: String? = nil
    @Published var insuranceValueError: String? = nil
    @Published var descriptionError: String? = nil
    @Published var safetyInstructionsError: String? = nil
    @Published var minKmError: String? = nil
    @Published var maxKmError: String? = nil
    @Published var extraKmPriceError: String? = nil

    // MARK: - Fetch Form Data

    func fetchFormData() {
        Task {
            showIndicator()
            let endpoint = AddAdEndpoint.formData()
            do {
                let data = try await request(endpoint)
                if let data = data {
                    self.mainCategories = data.mainCategories ?? []
                    self.carModels = data.carModels ?? []
                    self.carTypes = data.carTypes ?? []
                    self.cities = data.cities ?? []
                    self.fuelTypes = data.fuelTypes ?? []
                    self.isKilometerLimitEnabled = data.isKilometerLimitEnabled ?? false
                    self.isDeliveryToRenterLocationEnabled = data.isDeliveryToRenterLocationEnabled ?? false
                    self.isReceivedFromRenterLocationEnabled = data.isReceivedFromRenterLocationEnabled ?? false
                    self.isInsuranceValueEditable = data.isInsuranceValueEditable ?? true
                    self.isExtraKilometerPriceEditable = data.isExtraKilometerPriceEditable ?? false
                    self.defaultExtraKilometerPrice = data.defaultExtraKilometerPrice ?? 0.0
                    self.extraKilometerPrice = data.defaultExtraKilometerPrice != nil ? String(data.defaultExtraKilometerPrice!) : ""
                }
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }

    // MARK: - Fetch Category Details

    func fetchCategoryDetails() {
        guard let categoryId = selectedMainCategory?.id else { return }

        // Clear previous selection
        selectedSubCategory = nil
        subCategories = []
        additionalFeatures = []
        selectedAdditionalFeatureIds = []

        // Set insurance value from category if not editable
        if !isInsuranceValueEditable {
            insuranceValue = String(selectedMainCategory?.insuranceValue ?? 0)
        }

        Task {
            showIndicator()
            let endpoint = AddAdEndpoint.mainCategoryDetails(mainCategoryId: categoryId)
            do {
                let data = try await request(endpoint)
                if let data = data {
                    self.subCategories = data.subCategories ?? []
                    self.additionalFeatures = data.additionalFeatures ?? []
                }
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }

    // MARK: - Toggle Additional Feature

    func toggleAdditionalFeature(_ featureId: Int) {
        if selectedAdditionalFeatureIds.contains(featureId) {
            selectedAdditionalFeatureIds.remove(featureId)
        } else {
            selectedAdditionalFeatureIds.insert(featureId)
        }
    }

    // MARK: - Location Selected

    func setLocation(latitude: Double, longitude: Double, address: String) {
        selectedLatitude = latitude
        selectedLongitude = longitude
        selectedAddress = address
        locationError = ""
    }

    // MARK: - Validation

    func validateForm() -> Bool {
        var isValid = true

        // Images
        if mediaItems.isEmpty {
            mediaError = "At least one image is required".localized
            isValid = false
        } else {
            mediaError = nil
        }

        // Car Type
        if selectedCarType == nil {
            carTypeError = "add_ad.select_car_type".localized
            isValid = false
        } else {
            carTypeError = ""
        }

        // Car Model
        if selectedCarModel == nil {
            carModelError = "add_ad.select_car_model".localized
            isValid = false
        } else {
            carModelError = ""
        }

       //  Fuel Type
        if selectedFuelType == nil {
            fuelTypeError = "add_ad.select_fuel_type".localized
            isValid = false
        } else {
            fuelTypeError = ""
        }

        // Main Category
        if selectedMainCategory == nil {
            mainCategoryError = "add_ad.select_main_category".localized
            isValid = false
        } else {
            mainCategoryError = ""
        }

        // Sub Category
        if selectedSubCategory == nil {
            subCategoryError = "add_ad.select_sub_category".localized
            isValid = false
        } else {
            subCategoryError = ""
        }

        // City
        if selectedCity == nil {
            cityError = "add_ad.select_city".localized
            isValid = false
        } else {
            cityError = ""
        }

        // Location
        if selectedLatitude == nil || selectedLongitude == nil {
            locationError = "add_ad.select_location".localized
            isValid = false
        } else {
            locationError = ""
        }

        // Price Per Day
        if pricePerDay.isEmpty {
            pricePerDayError = "add_ad.enter_price".localized
            isValid = false
        } else {
            pricePerDayError = nil
        }

        // Insurance Value
        if isInsuranceValueEditable && insuranceValue.isEmpty {
            insuranceValueError = "add_ad.enter_insurance".localized
            isValid = false
        } else {
            insuranceValueError = nil
        }

        // Description
        if description.isEmpty {
            descriptionError = "add_ad.enter_description".localized
            isValid = false
        } else {
            descriptionError = nil
        }

        // Kilometer fields (only if enabled)
        if isKilometerLimitEnabled {
            if minKilometersUsage.isEmpty {
                minKmError = "add_ad.min_km".localized
                isValid = false
            } else {
                minKmError = nil
            }

            if maxKilometersUsage.isEmpty {
                maxKmError = "add_ad.max_km".localized
                isValid = false
            } else {
                maxKmError = nil
            }
        }

        if isExtraKilometerPriceEditable && extraKilometerPrice.isEmpty {
            extraKmPriceError = "add_ad.extra_km_price".localized
            isValid = false
        } else {
            extraKmPriceError = nil
        }

        return isValid
    }

    // MARK: - Create Advertisement

    func createAdvertisement() {
        guard validateForm() else { return }

        // Convert media items to UploadData
        var uploads: [UploadData] = []
        for (index, item) in mediaItems.enumerated() {
            if let imageData = item.image.jpegData(compressionQuality: 0.7) {
                uploads.append(UploadData(
                    key: "Images[\(index)].Image",
                    data: imageData,
                    mimeType: .jpeg
                ))
            }
        }

        Task {
            showIndicator()
            let endpoint = AddAdEndpoint.create(
                mainCategoryId: selectedMainCategory!.id,
                subCategoryId: selectedSubCategory!.id,
                carModelId: selectedCarModel!.id,
                carName: selectedCarModel!.name,
                fuelType: selectedFuelType!.id,
                carTypeId: selectedCarType!.id,
                pricePerDay: Double(pricePerDay) ?? 0,
                description: description,
                safetyInstructions: safetyInstructions.isEmpty ? nil : safetyInstructions,
                cityId: selectedCity!.id,
                latitude: selectedLatitude!,
                longitude: selectedLongitude!,
                images: uploads,
                minKilometersUsage: isKilometerLimitEnabled ? minKilometersUsage : nil,
                maxKilometersUsage: isKilometerLimitEnabled ? maxKilometersUsage : nil,
                extraKilometerPrice: isExtraKilometerPriceEditable ? extraKilometerPrice : nil,
                insuranceValue: insuranceValue.isEmpty ? nil : insuranceValue,
                isDeliveryEnabled: isDeliveryToRenterLocationEnabled ? isDeliveryEnabled : nil,
                isReceiveEnabled: isReceivedFromRenterLocationEnabled ? isReceiveEnabled : nil,
                additionalFeatureIds: Array(selectedAdditionalFeatureIds)
            )

            do {
                let data = try await request(endpoint)
                createdAdId = data?.id
                showSuccessPopup = true
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }
}
