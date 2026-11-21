//
//  MyAdDetailsTitleSectionView.swift
//  RentNow
//

import SwiftUI

struct MyAdDetailsTitleSectionView: View {

    let statusText: String?
    let mainCategoryName: String
    let subCategoryName: String
    let carName: String
    let pricePerDay: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Status Badge
            if let statusText = statusText, !statusText.isEmpty {
                HStack {
                    Spacer()
                    Text(statusText)
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(.orange)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.hint)
                        .cornerRadius(4)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }

            // Title Section (breadcrumb + car name + price)
            VStack(alignment: .leading, spacing: 8) {
                // Breadcrumb
                HStack(spacing: 4) {
                    Text(mainCategoryName)
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor(.black.opacity(0.8))
                    Text(".")
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor(.black.opacity(0.8))
                    Text(subCategoryName)
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor(.black.opacity(0.8))
                }

                // Car Name
                Text(carName)
                    .expoSystemFont(size: FontSize.large, weight: .bold)
                    .foregroundColor(.black)

                // Price
                HStack(spacing: 4) {
                    Text("\(Int(pricePerDay)) " + "SAR".localized)
                        .expoSystemFont(size: FontSize.large, weight: .bold)
                        .foregroundColor(.mainColor)
                    Text("/ " + "per_day".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor(.gray)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)
        }
    }
}

#Preview {
    MyAdDetailsTitleSectionView(
        statusText: "Under Review",
        mainCategoryName: "Cars",
        subCategoryName: "Sedan",
        carName: "Toyota Camry 2024",
        pricePerDay: 150
    )
}
