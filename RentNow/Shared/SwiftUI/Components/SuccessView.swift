//
//  SuccessView.swift
//  RentNow
//

import SwiftUI

struct SuccessView: View {
    let title: String
    let subtitle: String
    var onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            GifImageView(name: "sucess")
                .frame(width: 150, height: 150)

            Text(title)
                .expoSystemFont(size: FontSize.large, weight: .bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text(subtitle)
                .expoSystemFont(size: FontSize.normal, weight: .regular)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                onDismiss()
            }
        }
    }
}
