//
//  WalletActionButton.swift
//  RentNow
//

import SwiftUI

struct WalletActionButton: View {
    let title: String
    var isFilled: Bool = true
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .expoSystemFont(size: FontSize.large, weight: .medium)
                .foregroundColor(isFilled ? .white : .mainColor)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isFilled ? Color.mainColor : Color.clear)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.mainColor, lineWidth: isFilled ? 0 : 1)
                )
        }
    }
}

#Preview {
    HStack(spacing: 12) {
        WalletActionButton(title: "Recharge", isFilled: true) {}
        WalletActionButton(title: "Withdraw", isFilled: false) {}
    }
    .padding()
}
