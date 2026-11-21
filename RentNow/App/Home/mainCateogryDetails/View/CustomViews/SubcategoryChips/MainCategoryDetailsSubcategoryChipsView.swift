//
//  MainCategoryDetailsSubcategoryChipsView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct MainCategoryDetailsSubcategoryChipsView: View {

    let subCategories: [SubCategory]
    let selectedId: Int?
    var onSelect: (Int) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Array(subCategories.enumerated()), id: \.element.id) { index, subCategory in
                    Button {
                        onSelect(subCategory.id)
                    } label: {
                        HStack(spacing: 8) {

                            if index == 0 {
                                Image("AllCars")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                            } else if let imageUrl = subCategory.imageUrl {
                                RemoteImageView(url: imageUrl)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                            }

                            Text(subCategory.name)
                                .expoSystemFont(
                                    size: FontSize.small,
                                    weight: isSelected(subCategory.id) ? .bold : .regular
                                )
                                .foregroundColor(isSelected(subCategory.id) ? .black : .text)

                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .glassyBackground()
                        .overlay(
                            RoundedRectangle(cornerRadius:16 )
                                .stroke(isSelected(subCategory.id) ? .main : .clear, lineWidth: 1)
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 8)
    }

    private func isSelected(_ id: Int) -> Bool {
         let currentSelection = selectedId ?? 0
        return currentSelection == id
    }
}


