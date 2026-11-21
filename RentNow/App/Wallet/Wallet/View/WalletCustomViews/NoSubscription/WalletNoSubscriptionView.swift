//
//  WalletNoSubscriptionView.swift
//  RentNow
//
//  Created by Claude on 2026-02-08.
//

import SwiftUI
import Lottie

struct WalletNoSubscriptionView: View {

    var onSubscribeTap: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Spacer()

            LottieSwiftUIView(animationName: "Wallet", loopMode: .loop)
                .frame(width: 150, height: 150)

            Text("No active subscription".localized)
                .expoSystemFont(size: FontSize.large, weight: .medium)
                .foregroundColor(Color(hex: "#080808"))
                .multilineTextAlignment(.center)

            DarkBluePillButton(title: "Subscribe to a package".localized) {
                onSubscribeTap()
            }
            .padding(.horizontal, 8)

            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    WalletNoSubscriptionView(onSubscribeTap: {})
}
