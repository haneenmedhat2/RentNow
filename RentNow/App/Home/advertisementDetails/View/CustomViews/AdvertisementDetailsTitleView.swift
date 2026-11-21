//
//  AdvertisementDetailsTitleView.swift
//  RentNow
//

import SwiftUI

struct AdvertisementDetailsTitleView: View {

    let mainCategoryName: String
    let subCategoryName: String
    let carNameText: String
    let averageRating: Double?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            breadcrumb
            carName
            if let rating = averageRating {
                ratingStars(rating: rating)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    // MARK: - Breadcrumb

    private var breadcrumb: some View {
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
    }

    // MARK: - Car Name

    private var carName: some View {
        Text(carNameText)
            .expoSystemFont(size: FontSize.large, weight: .bold)
            .foregroundColor(.black)
    }

    // MARK: - Rating Stars

    private func ratingStars(rating: Double) -> some View {
        HStack(spacing: 4) {
            Image("star")
                .scaledToFill()
                .frame(width: 15 , height: 15)
            
            Text(String(format: "%.1f", rating))
                .expoSystemFont(size: FontSize.small, weight: .semiBold)
                .foregroundColor(.black)
        }
    }
}
