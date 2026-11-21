//
//  WalletSubscriptionCardView.swift
//  RentNow
//
//  Created by Claude on 2026-02-08.
//

import SwiftUI

struct WalletSubscriptionCardView: View {

    let packageName: String
    let durationText: String
    let price: Double
    let description: String
    let deliveryTimesCount: Int
    let discountPercentage: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header: package name + duration badge
            HStack(spacing: 8) {
                Text(packageName)
                    .expoSystemFont(size: FontSize.large, weight: .medium)
                    .foregroundColor(.greyScale950)

                Spacer()

                Text(durationText)
                    .expoSystemFont(size: FontSize.normal, weight: .regular)
                    .foregroundColor(.darkTextColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 6)
                    .background(Color.lightBlueBorderColor)
                    .cornerRadius(2)
            }

            // Price with Riyal symbol
            HStack(spacing: 4) {
                Text(String(format: "%.0f", price))
                    .expoSystemFont(size: 24, weight: .semiBold)
                    .foregroundColor(.mainColor)

                Image("riyal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }

            // Description
            if !description.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Description".localized)
                        .expoSystemFont(size: FontSize.small, weight: .semiBold)
                        .foregroundColor(.subtitleTextColor)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(description)
                        .expoSystemFont(size: FontSize.small, weight: .regular)
                        .foregroundColor(.subtitleTextColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            // Details
            VStack(spacing: 6) {
                // Remaining free delivery times
                HStack(spacing: 6) {
                    Text("Remaining free delivery times".localized)
                        .expoSystemFont(size: FontSize.small, weight: .medium)
                        .foregroundColor(.subtitleTextColor)

                    Spacer()

                    Text("\(deliveryTimesCount)")
                        .expoSystemFont(size: FontSize.small, weight: .medium)
                        .foregroundColor(.darkTextColor)
                }

                // Discount percentage
                HStack(spacing: 6) {
                    Text("Discount percentage".localized)
                        .expoSystemFont(size: FontSize.small, weight: .medium)
                        .foregroundColor(.subtitleTextColor)

                    Spacer()

                    Text(String(format: "%.0f%%", discountPercentage))
                        .expoSystemFont(size: FontSize.small, weight: .medium)
                        .foregroundColor(.darkTextColor)
                }
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.24))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.primaryColor50, lineWidth: 1)
        )
        .cornerRadius(4)
    }
}

#Preview {
    WalletSubscriptionCardView(
        packageName: "Gold Package",
        durationText: "3 months",
        price: 15,
        description: "This is an example description that can be replaced.",
        deliveryTimesCount: 3,
        discountPercentage: 15
    )
    .padding()
}
