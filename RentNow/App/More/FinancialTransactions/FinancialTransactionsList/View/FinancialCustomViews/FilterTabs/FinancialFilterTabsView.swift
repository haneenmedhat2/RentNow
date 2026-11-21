//
//  FinancialFilterTabsView.swift
//  RentNow
//

import SwiftUI

struct FinancialFilterTabsView: View {
    let selectedTab: FinancialTabType
    var onTabSelected: (FinancialTabType) -> Void

    var body: some View {
        HStack(spacing: 0) {
            ForEach(FinancialTabType.allCases) { tab in
                Button {
                    onTabSelected(tab)
                } label: {
                    Text(tab.title)
                        .expoSystemFont(
                            size: FontSize.small,
                            weight: tab == selectedTab ? .bold : .medium
                        )
                        .foregroundColor(tab == selectedTab ? .white : .text)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            tab == selectedTab
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
        FinancialFilterTabsView(
            selectedTab: .outstanding,
            onTabSelected: { _ in }
        )
        .padding()
    }
}
