//
//  MyAdsFilterTabsView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct MyAdsFilterTabsView: View {
    let selectedFilter: MyAdFilterType
    var onFilterSelected: (MyAdFilterType) -> Void

    var body: some View {
        HStack(spacing: 0) {
            ForEach(MyAdFilterType.allCases, id: \.self) { filter in
                Button {
                    onFilterSelected(filter)
                } label: {
                    Text(filter.title)
                        .expoSystemFont(
                            size: FontSize.small,
                            weight: filter == selectedFilter ? .bold : .medium
                        )
                        .foregroundColor(filter == selectedFilter ? .white : .text)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            filter == selectedFilter
                            ? Capsule().fill(Color.mainColor)
                            : Capsule().fill(Color.clear)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .glassyBackground(cornerRadius: 24)
    }
}

#Preview {
    ZStack {
        MainGradientView()
        MyAdsFilterTabsView(
            selectedFilter: .underReview,
            onFilterSelected: { _ in }
        )
        .padding()
    }
}
