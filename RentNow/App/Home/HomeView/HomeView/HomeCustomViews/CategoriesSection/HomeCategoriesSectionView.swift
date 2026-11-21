//
//  HomeCategoriesSectionView.swift
//  RentNow
//
//  Created by Elshamy on 25/01/2026.
//

import SwiftUI

struct HomeCategoriesSectionView: View {
    let categories: [CategoryItem]
    var onCategoryTap: (Int, String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section Title
            Text("categories_section_title".localized)
                .expoSystemFont(size: FontSize.large, weight: .bold)
                .foregroundColor(.black)

            // Categories Grid (2x2)
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                ForEach(categories, id: \.id) { category in
                    categoryCard(category: category)
                }
            }
        }
    }

    private func categoryCard(category: CategoryItem) -> some View {
        Button {
            onCategoryTap(category.id, category.name)
        } label: {
            VStack(spacing: 12) {
                // Category Image
               
                        if let imageUrl = category.imageUrl {
                            RemoteImageView(url: imageUrl)
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else if let image = category.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "car.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.mainColor)
                        }
                    

                // Category Name
                Text(category.name)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.5))
                    .stroke(Color.mainColor.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

#Preview {
    HomeCategoriesSectionView(
        categories: CategoryItem.placeholder,
        onCategoryTap: { _, _ in }
    )
}
