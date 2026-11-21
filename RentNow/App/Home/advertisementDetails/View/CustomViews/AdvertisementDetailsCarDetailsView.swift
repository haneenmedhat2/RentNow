//
//  AdvertisementDetailsCarDetailsView.swift
//  RentNow
//

import SwiftUI

struct AdvertisementDetailsCarDetailsView: View {

    let fuelType: String
    let description: String
    let safetyInstructions: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle
            fuelTypeRow

            descriptionLabel
            descriptionText

            if let safetyInstructions = safetyInstructions, !safetyInstructions.isEmpty {
                safetyInstructionsLabel
                safetyInstructionsText(safetyInstructions)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .glassyBackground(cornerRadius: 8)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // MARK: - Section Title

    private var sectionTitle: some View {
        Text("Fuel type".localized)
            .expoSystemFont(size: FontSize.normal, weight: .bold)
            .foregroundColor(.black)
    }

    // MARK: - Fuel Type Row

    private var fuelTypeRow: some View {
        HStack(spacing: 8) {
            Image("fuel-02")
                .scaledToFill()
                .frame(width: 15 , height: 15)
            Text(fuelType)
                .expoSystemFont(size: FontSize.normal, weight: .regular)
                .foregroundColor(.black.opacity(0.9))
        }
    }

    // MARK: - Description

    private var descriptionLabel: some View {
        Text("ad_details_description".localized)
            .expoSystemFont(size: FontSize.normal, weight: .bold)
            .foregroundColor(.black.opacity(0.9))
    }

    private var descriptionText: some View {
        Text(description)
            .expoSystemFont(size: FontSize.normal, weight: .regular)
            .foregroundColor(.black.opacity(0.8))
    }

    // MARK: - Safety Instructions

    private var safetyInstructionsLabel: some View {
        Text("ad_details_safety_instructions".localized)
            .expoSystemFont(size: FontSize.normal, weight: .bold)
            .foregroundColor(.black.opacity(0.9))
    }

    private func safetyInstructionsText(_ text: String) -> some View {
        Text(text)
            .expoSystemFont(size: FontSize.normal, weight: .regular)
            .foregroundColor(.black.opacity(0.8))
    }
}
