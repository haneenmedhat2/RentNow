//
//  EditAdViewModel.swift
//  RentNow
//
//  Created by Claude Code
//

import Foundation
import SwiftUI
import Combine
import Kingfisher

@MainActor
final class EditAdViewModel: BaseViewModel {

    let adId: Int

    // MARK: - Form Fields
    @Published var pricePerDay: String = ""
    @Published var insuranceValue: String = ""
    @Published var descriptionText: String = ""
    @Published var safetyInstructions: String = ""
    @Published var minKilometersUsage: String = ""
    @Published var maxKilometersUsage: String = ""
    @Published var extraKilometerPrice: String = ""
    @Published var isDeliveryEnabled: Bool = false

    // MARK: - Images
    @Published var mediaItems: [MediaItem] = []
    /// Maps MediaItem.id → original server URL for items downloaded from existing images
    var existingImageMap: [UUID: String] = [:]

    // MARK: - Additional Features (toggleable)
    @Published var additionalFeatures: [AdditionalFeatureItem] = []
    @Published var selectedAdditionalFeatureIds: Set<Int> = []

    // MARK: - Config Flags (from FormData / CategoryDetails)
    @Published var isKilometerLimitEnabled: Bool = false
    @Published var isInsuranceValueEditable: Bool = true
    @Published var isExtraKilometerPriceEditable: Bool = false

    // MARK: - Error Strings
    @Published var pricePerDayError: String? = nil
    @Published var insuranceValueError: String? = nil
    @Published var descriptionError: String? = nil
    @Published var safetyInstructionsError: String? = nil
    @Published var minKmError: String? = nil
    @Published var maxKmError: String? = nil
    @Published var extraKmPriceError: String? = nil
    @Published var mediaError: String? = nil

    // MARK: - State
    @Published var isEdited = false

    var maxImageCount: Int { 3 }

    var totalImageCount: Int { mediaItems.count }

    var canAddMoreImages: Bool { totalImageCount < maxImageCount }

    var remainingImageSlots: Int { maxImageCount - totalImageCount }

    // MARK: - Init

    init(details: MyAdDetailsData) {
        self.adId = details.id ?? 0
        super.init()
        populateFields(from: details)
    }

    // MARK: - Populate

    private func populateFields(from details: MyAdDetailsData) {
        pricePerDay = details.pricePerDay != nil ? String(Int(details.pricePerDay!)) : ""
        insuranceValue = details.insurranceValue != nil ? String(Int(details.insurranceValue!)) : ""
        descriptionText = details.description ?? ""
        safetyInstructions = details.safetyInstructions ?? ""
        minKilometersUsage = details.minKilometersUsage != nil ? String(Int(details.minKilometersUsage!)) : ""
        maxKilometersUsage = details.maxKilometersUsage != nil ? String(Int(details.maxKilometersUsage!)) : ""
        extraKilometerPrice = details.extraKilometerPrice != nil ? String(Int(details.extraKilometerPrice!)) : ""
        isDeliveryEnabled = details.isDeliveryToRenterLocationEnabled ?? false
        isKilometerLimitEnabled = (details.minKilometersUsage ?? 0) > 0 || (details.maxKilometersUsage ?? 0) > 0
        isExtraKilometerPriceEditable = (details.extraKilometerPrice ?? 0) > 0
        isInsuranceValueEditable = true

        let features = details.additionalFeatures ?? []
        additionalFeatures = features
        selectedAdditionalFeatureIds = Set(features.filter { $0.isSelected == true }.compactMap { $0.id })

        // Load images from Kingfisher cache (already cached from details screen)
        let imageUrls = details.images ?? []
        Task {
            showIndicator()
            for urlString in imageUrls {
                guard let url = URL(string: urlString) else { continue }
                if let image = await loadImageFromKingfisher(url: url) {
                    let item = MediaItem(image: image)
                    existingImageMap[item.id] = urlString
                    mediaItems.append(item)
                }
            }
            hideIndicator()
        }
    }

    private func loadImageFromKingfisher(url: URL) async -> UIImage? {
        await withCheckedContinuation { continuation in
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let value): continuation.resume(returning: value.image)
                case .failure: continuation.resume(returning: nil)
                }
            }
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

    // MARK: - Validation

    func validateForm() -> Bool {
        var isValid = true

        if mediaItems.isEmpty {
            mediaError = "At least one image is required".localized
            isValid = false
        } else {
            mediaError = nil
        }

        if pricePerDay.isEmpty {
            pricePerDayError = "Enter price per day".localized
            isValid = false
        } else {
            pricePerDayError = nil
        }

        if isInsuranceValueEditable && insuranceValue.isEmpty {
            insuranceValueError = "Enter insurance price".localized
            isValid = false
        } else {
            insuranceValueError = nil
        }

        if descriptionText.isEmpty {
            descriptionError = "Enter car description".localized
            isValid = false
        } else {
            descriptionError = nil
        }

        if isKilometerLimitEnabled {
            if minKilometersUsage.isEmpty {
                minKmError = "Minimum Kilometers".localized
                isValid = false
            } else {
                minKmError = nil
            }

            if maxKilometersUsage.isEmpty {
                maxKmError = "Maximum Kilometers".localized
                isValid = false
            } else {
                maxKmError = nil
            }
        }

        if isExtraKilometerPriceEditable && extraKilometerPrice.isEmpty {
            extraKmPriceError = "Extra Kilometer Price".localized
            isValid = false
        } else {
            extraKmPriceError = nil
        }

        return isValid
    }

    // MARK: - Edit Ad

    func editAd() {
        guard validateForm() else { return }

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

            let endpoint = MoreEndpoint.editAd(
                id: adId,
                description: descriptionText,
                safetyInstructions: safetyInstructions.isEmpty ? nil : safetyInstructions,
                pricePerDay: Double(pricePerDay) ?? 0,
                insuranceValue: Double(insuranceValue) ?? 0,
                isDeliveryEnabled: isDeliveryEnabled,
                minKilometersUsage: isKilometerLimitEnabled ? minKilometersUsage : nil,
                maxKilometersUsage: isKilometerLimitEnabled ? maxKilometersUsage : nil,
                extraKilometerPrice: isExtraKilometerPriceEditable ? extraKilometerPrice : nil,
                additionalFeatureIds: Array(selectedAdditionalFeatureIds),
                images: uploads
            )

            do {
                let _ = try await request(endpoint)
                showSuccess("Ad updated successfully".localized)
                isEdited = true
            } catch {
                showError(error.localizedDescription)
            }

            hideIndicator()
        }
    }
}
