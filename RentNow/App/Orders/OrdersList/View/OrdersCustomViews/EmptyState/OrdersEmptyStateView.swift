//
//  OrdersEmptyStateView.swift
//  RentNow
//
//  Created by Claude on 2026-02-09.
//

import SwiftUI

struct OrdersEmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.system(size: 50))
                .foregroundColor(.grayTextColor)

            Text("No orders available".localized)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.grayTextColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ZStack {
        MainGradientView()
        OrdersEmptyStateView()
    }
}
