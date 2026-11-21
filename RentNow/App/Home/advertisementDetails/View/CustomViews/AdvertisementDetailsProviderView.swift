//
//  AdvertisementDetailsProviderView.swift
//  RentNow
//

import SwiftUI

struct AdvertisementDetailsProviderView: View {

    let provider: AdvertisementProvider
    var onProviderTap: () -> Void

    var body: some View {
        Button(action: onProviderTap) {
            VStack(alignment: .leading, spacing: 12) {
                sectionTitle
                providerRow
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .glassyBackground(cornerRadius: 8)
            .padding(.horizontal, 16)
            .padding(.top, 8)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Section Title

    private var sectionTitle: some View {
        Text("ad_details_provider".localized)
            .expoSystemFont(size: FontSize.normal, weight: .bold)
            .foregroundColor(.black)
    }

    // MARK: - Provider Row

    private var providerRow: some View {
        HStack(spacing: 12) {
            RemoteImageView(url: (provider.providerImage ?? "").isEmpty ? nil : provider.providerImage)
                .frame(width: 48, height: 48)
                .clipShape(Circle())

            Text(provider.providerName ?? "")
                .expoSystemFont(size: FontSize.small, weight: .semiBold)
                .foregroundColor(.black)
        }
    }
}
