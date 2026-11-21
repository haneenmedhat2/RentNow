//
//  OrderDetailsOrderCardView.swift
//  RentNow
//

import SwiftUI

struct UserCardView: View {
    let providerInfo: userInfoData
    let order: OrderData
    let formattedDate: String
    var title: String = "For the renter".localized

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Provider label
            Text(title)
                .expoSystemFont(size: FontSize.normal, weight: .regular)
                .foregroundColor(.grayTextColor)

            // Provider info
            HStack(spacing: 10) {
                RemoteImageView(url: providerInfo.profileImage)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())

                Text(providerInfo.userName ?? "")
                    .expoSystemFont(size: FontSize.normal, weight: .bold)
                    .foregroundColor(.black)
            }

            // Order details label
            Text("Order Details".localized)
                .expoSystemFont(size: FontSize.normal, weight: .regular)
                .foregroundColor(.grayTextColor)

            // Order number + status
            HStack(spacing: 8) {
                Image("orderIcon")
                    .frame(width: 30, height: 30)
                    .scaledToFill()

                VStack(alignment: .leading, spacing: 6) {
                    Text("#\(order.orderNumber ?? "")")
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(.mainColor)
                    Text(formattedDate)
                        .expoSystemFont(size: FontSize.small, weight: .regular)
                        .foregroundColor(.text)
                }

                Spacer()

                Text(order.statusText ?? "")
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(Color(hex: order.statusColor ?? "#000000"))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(hex: order.backgroundColor ?? "#FFFFFF"))
                    .cornerRadius(8)
            }
        }
        .padding(16)
        .glassyBackground(cornerRadius: 16)
    }
}

