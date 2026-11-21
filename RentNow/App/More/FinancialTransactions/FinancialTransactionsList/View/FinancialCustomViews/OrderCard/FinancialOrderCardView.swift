//
//  FinancialOrderCardView.swift
//  RentNow
//

import SwiftUI

struct FinancialOrderCardView: View {
    let order: WaitingSettlementItem

    var body: some View {
        VStack(spacing: 8) {
            // Header: Order Details title
            Text("Order Details".localized)
                .expoSystemFont(size: FontSize.small, weight: .medium)
                .foregroundColor(.darkTextColor)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Order number + time
            HStack(spacing: 8) {
                Image("orderIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .background(Color.lightBlueBorderColor.opacity(0.5))
                    .clipShape(Circle())

                Text("#\(order.id ?? 0)")
                    .expoSystemFont(size: FontSize.normal, weight: .semiBold)
                    .foregroundColor(.mainColor)

                Spacer()

                if let since = order.since, !since.isEmpty {
                    Text(since)
                        .expoSystemFont(size: FontSize.altraSmall, weight: .regular)
                        .foregroundColor(.subtitleTextColor)
                }
            }

            // Price rows
            VStack(spacing: 8) {
                priceRow(label: "Order Value".localized, value: order.price ?? "0")
                priceRow(label: "App commission".localized, value: order.vat ?? "0")
                priceRow(label: "Commission discount".localized, value: order.commissionDiscount ?? "0")
            }

            Divider()

            // Total
            HStack(spacing: 4) {
                Text("Total".localized)
                    .expoSystemFont(size: FontSize.small, weight: .regular)
                    .foregroundColor(.subtitleTextColor)

                Spacer()

                Text(order.amountDue ?? "0")
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.mainColor)

                Image("riyal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
        }
        .padding(8)
        .background(Color.white.opacity(0.24))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.borderColor, lineWidth: 1)
        )
        .cornerRadius(4)
    }

    private func priceRow(label: String, value: String) -> some View {
        HStack(spacing: 4) {
            Text(label)
                .expoSystemFont(size: FontSize.small, weight: .regular)
                .foregroundColor(.subtitleTextColor)

            Spacer()

            Text(value)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.darkTextColor)

            Image("riyal")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
        }
        .frame(height: 24)
    }
}
