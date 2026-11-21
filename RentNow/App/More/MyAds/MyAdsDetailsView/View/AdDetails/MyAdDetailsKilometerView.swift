//
//  MyAdDetailsKilometerView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct MyAdDetailsKilometerView: View {

    let minKm: Double
    let maxKm: Double
    let extraKmPrice: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Kilometer Calculation Service Details".localized)
                .expoSystemFont(size: FontSize.normal, weight: .bold)
                .foregroundColor(.black)

            HStack {
                Text("Min Kilometers".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .regular)
                    .foregroundColor(.black.opacity(0.9))
                Spacer()
                Text("\(Int(minKm)) " + "km".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .semiBold)
                    .foregroundColor(.black.opacity(0.9))
            }

            HStack {
                Text("Max Kilometers".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .regular)
                    .foregroundColor(.black.opacity(0.9))
                Spacer()
                Text("\(Int(maxKm)) " + "km".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .semiBold)
                    .foregroundColor(.black.opacity(0.9))
            }

            HStack {
                Text("Extra Kilometer Price".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .regular)
                    .foregroundColor(.black.opacity(0.9))
                Spacer()
                Text("\(Int(extraKmPrice)) " + "SAR".localized)
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
