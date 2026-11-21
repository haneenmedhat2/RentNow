//
//  MainCategoryDetailsSearchBarView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct MainCategoryDetailsSearchBarView: View {

    @Binding var searchText: String
    var hasActiveFilters: Bool = false
    var onFilterTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                Image("SearchIcon 1")
                    .scaledToFill()
                    .frame(width: 30 , height: 30)

                TextField("search_placeholder".localized, text: $searchText)
                    .expoSystemFont(size: FontSize.small, weight: .regular)

                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
//                        Image(systemName: "xmark.circle.fill")
//                            .foregroundColor(.gray)
//                            .font(.system(size: 16))
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .glassyBackground()
            .cornerRadius(12)

            Button {
                onFilterTap()
            } label: {
                ZStack(alignment: .topTrailing) {
                    Image("filterIcon")
                        .scaledToFill()
                        .frame(width: 40 , height: 40)
                        

                    if hasActiveFilters {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                            .offset(x: 2, y: -2)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    MainCategoryDetailsSearchBarView(
        searchText: .constant(""),
        onFilterTap: {}
    )
}
