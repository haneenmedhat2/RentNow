//
//  AdvertisementDetailsLocationView.swift
//  RentNow
//

import SwiftUI

struct AdvertisementDetailsLocationView: View {

    let cityName: String
    let geoAddress: String
    let hasValidLocation: Bool
    let onLocationTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle
            cityRow
            addressRow
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .glassyBackground(cornerRadius: 8)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // MARK: - Section Title

    private var sectionTitle: some View {
        Text("ad_details_location".localized)
            .expoSystemFont(size: FontSize.normal, weight: .bold)
            .foregroundColor(.black)
    }

    // MARK: - City Row

    private var cityRow: some View {
        HStack(spacing: 8) {
            Image("city-01")
                .scaledToFill()
                .frame(width: 15 , height: 15)
            Text(cityName)
                .expoSystemFont(size: FontSize.normal, weight: .regular)
                .foregroundColor(.black.opacity(0.9))
        }
    }

    // MARK: - Address Row

    private var addressRow: some View {
        HStack(spacing: 8) {
            Image("pin-location-01")
                .scaledToFill()
                .frame(width: 15 , height: 15)
            Text(geoAddress)
                .expoSystemFont(size: FontSize.normal, weight: .regular)
                .foregroundColor(.black.opacity(0.9))
                .underline(hasValidLocation)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onTapGesture {
            onLocationTap()
        }
    }
}
