//
//  OrdersFilterTabsView.swift
//  RentNow
//
//  Created by Claude on 2026-02-09.
//

import SwiftUI

struct OrdersFilterTabsView: View {
    let selectedFilter: OrderFilterType
    var onFilterSelected: (OrderFilterType) -> Void

    var body: some View {
        HStack(spacing: 0) {
            ForEach(OrderFilterType.allCases, id: \.self) { filter in
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
        OrdersFilterTabsView(
            selectedFilter: .new,
            onFilterSelected: { _ in }
        )
        .padding()
    }
}
