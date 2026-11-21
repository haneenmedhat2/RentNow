//
//  MyAdDetailsOtherDetailsView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct MyAdDetailsOtherDetailsView: View {

    let insurancePrice: Double
    let isDeliveryToRenterLocationEnabled: Bool

    private var deliveryText: String {
        isDeliveryToRenterLocationEnabled
            ? "Delivery to renter location".localized
            : "Pickup from owner location".localized
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Other Details".localized)
                .expoSystemFont(size: FontSize.normal, weight: .bold)
                .foregroundColor(.black)

            HStack {
                Text("Insurance Price".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .regular)
                    .foregroundColor(.black.opacity(0.9))
                Spacer()
                Text("\(Int(insurancePrice)) " + "SAR".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .semiBold)
                    .foregroundColor(.black.opacity(0.9))
            }

            HStack {
                Text("Delivery Method".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .regular)
                    .foregroundColor(.black.opacity(0.9))
                Spacer()
                Text(deliveryText)
                    .expoSystemFont(size: FontSize.normal, weight: .semiBold)
                    .foregroundColor(.black.opacity(0.9))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .glassyBackground(cornerRadius: 8)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}
