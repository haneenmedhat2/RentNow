//
//  AddAdFormDataModel.swift
//  RentNow
//
//  Created by Claude Code
//

import Foundation

// MARK: - Form Data Response
struct AddAdFormData: Codable {
    let mainCategories: [AddAdMainCategory]?
    let carModels: [CarModel]?
    let carTypes: [AddAdCarType]?
    let cities: [FilterCity]?
    let fuelTypes: [FuelType]?
    let isKilometerLimitEnabled: Bool?
    let isDeliveryToRenterLocationEnabled: Bool?
    let isReceivedFromRenterLocationEnabled: Bool?
    let isInsuranceValueEditable: Bool?
    let isExtraKilometerPriceEditable: Bool?
    let defaultExtraKilometerPrice: Double?
    let taxDisclosureMessage: String?
    let cancellationAndModificationRules: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.mainCategories = try container.decodeIfPresent([AddAdMainCategory].self, forKey: .mainCategories) ?? []
        self.carModels = try container.decodeIfPresent([CarModel].self, forKey: .carModels) ?? []
        self.carTypes = try container.decodeIfPresent([AddAdCarType].self, forKey: .carTypes) ?? []
        self.cities = try container.decodeIfPresent([FilterCity].self, forKey: .cities) ?? []
        self.fuelTypes = try container.decodeIfPresent([FuelType].self, forKey: .fuelTypes) ?? []
        self.isKilometerLimitEnabled = try container.decodeIfPresent(Bool.self, forKey: .isKilometerLimitEnabled)
        self.isDeliveryToRenterLocationEnabled = try container.decodeIfPresent(Bool.self, forKey: .isDeliveryToRenterLocationEnabled)
        self.isReceivedFromRenterLocationEnabled = try container.decodeIfPresent(Bool.self, forKey: .isReceivedFromRenterLocationEnabled)
        self.isInsuranceValueEditable = try container.decodeIfPresent(Bool.self, forKey: .isInsuranceValueEditable)
        self.isExtraKilometerPriceEditable = try container.decodeIfPresent(Bool.self, forKey: .isExtraKilometerPriceEditable)
        self.defaultExtraKilometerPrice = try container.decodeIfPresent(Double.self, forKey: .defaultExtraKilometerPrice) ?? 0.0
        self.taxDisclosureMessage = try container.decodeIfPresent(String.self, forKey: .taxDisclosureMessage) ?? ""
        self.cancellationAndModificationRules = try container.decodeIfPresent(String.self, forKey: .cancellationAndModificationRules) ?? ""
    }
}

// MARK: - Main Category
struct AddAdMainCategory: Codable, GeneralPickerModel, Hashable {
    let id: Int
    let name: String
    let imageUrl: String?
    let insuranceValue: Double?
    let isActive: Bool?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        self.insuranceValue = try container.decodeIfPresent(Double.self, forKey: .insuranceValue) ?? 0.0
        self.isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive)
    }
}

// MARK: - Car Type
struct AddAdCarType: Codable, GeneralPickerModel, Hashable {
    let id: Int
    let name: String
    let imageUrl: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
    }
}

// MARK: - Category Details Response
struct AddAdCategoryDetails: Codable {
    let subCategories: [SubCategory]?
    let additionalFeatures: [AdditionalFeature]?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.subCategories = try container.decodeIfPresent([SubCategory].self, forKey: .subCategories) ?? []
        self.additionalFeatures = try container.decodeIfPresent([AdditionalFeature].self, forKey: .additionalFeatures) ?? []
    }
}

// MARK: - GeneralPickerModel Conformance

extension CarModel: GeneralPickerModel {}

extension FilterCity: GeneralPickerModel {}

extension FuelType: GeneralPickerModel {}

extension SubCategory: GeneralPickerModel {}
