//
//  MyAdsCardView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct MyAdsCardView: View {

    let ad: MyAdItem
    let statusText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                GeometryReader { geo in
                    RemoteImageView(url: ad.mainImageUrl)
                        .scaledToFill()
                        .frame(width: geo.size.width, height: 140)
                        .clipped()
                }
                .frame(minHeight: 140, maxHeight: 140)

                Text(statusText)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.hint)
                    .cornerRadius(4)
                    .padding(8)
            }
            .padding(.top, 8)
            .padding(.horizontal, 8)

            VStack(alignment: .leading, spacing: 6) {
                // Name
                Text(ad.carName ?? "")
                    .expoSystemFont(size: FontSize.large, weight: .semiBold)
                    .lineLimit(1)

                // City
                HStack(spacing: 4) {
                    Image("city-01")
                        .scaledToFill()
                        .frame(width: 15, height: 15)
                    Text(ad.cityName ?? "")
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor(.text)
                        .lineLimit(1)
                }

                // Address
                HStack(spacing: 4) {
                    Image("pin-location-01")
                        .scaledToFill()
                        .frame(width: 15, height: 15)
                    Text(ad.geoAddress ?? "")
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor(.text)
                        .lineLimit(1)
                }

                // Price
                HStack(spacing: 4) {
                    Text("\(Int(ad.pricePerDay ?? 0)) " + "SAR".localized)
                        .expoSystemFont(size: FontSize.large, weight: .bold)
                        .foregroundColor(.mainColor)
                    Text("/ " + "per_day".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .glassyBackground(cornerRadius: 0)
    }
}

