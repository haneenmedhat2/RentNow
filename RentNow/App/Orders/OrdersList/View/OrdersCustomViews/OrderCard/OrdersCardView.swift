//
//  OrdersCardView.swift
//  RentNow
//
//  Created by Claude on 2026-02-09.
//

import SwiftUI

struct OrdersCardView: View {
  
    let order:OrderItem
    
    var onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                // Renter label
                Text("For the renter".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .regular)
                    .foregroundColor(.grayTextColor)

                // Provider info
                HStack(spacing: 10) {
                    RemoteImageView(url: order.providerImage)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())

                    Text(order.providerName ?? "")
                        .expoSystemFont(size: FontSize.normal, weight: .bold)
                        .foregroundColor(.black)
                }

                // Order details label
                Text("Order Details".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .regular)
                    .foregroundColor(.grayTextColor)

                // Order number
                HStack(spacing: 8) {
                    Image("orderIcon")
                        .frame(width: 30 , height: 30)
                        .scaledToFill()
                    
                    VStack(alignment: .leading , spacing: 6) {
                        Text("#\(order.orderNumber ?? "")")
                            .expoSystemFont(size: FontSize.normal, weight: .bold)
                            .foregroundColor(.mainColor)
                        Text(order.creationDateFormatted ?? "")
                            .expoSystemFont(size: FontSize.small, weight: .regular)
                            .foregroundColor(.text)
                    }
                    
                    Spacer()
                    
                    
                    Text(order.orderStatusText ?? "")
                        .expoSystemFont(size: FontSize.small, weight: .medium)
                        .foregroundColor(Color(hex: order.statusColor ?? "#000000"))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(hex: order.backgroundColor ?? "#FFFFFF"))
                        .cornerRadius(8)
                       
                        
                }

                // Date
              

                // Status + chevron
                HStack {
                    Spacer()
                    Image("detailsButton")
                        .frame(width: 30 , height: 30)
                        .scaledToFill()
                }
            }
            .padding(16)
            .glassyBackground(cornerRadius: 16)
        }
        .buttonStyle(.plain)
    }
}


