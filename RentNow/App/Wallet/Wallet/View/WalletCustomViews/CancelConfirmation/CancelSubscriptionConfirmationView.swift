//
//  CancelSubscriptionConfirmationView.swift
//  RentNow
//
//  Created by Claude on 2026-03-23.
//

import SwiftUI

struct CancelSubscriptionConfirmationView: View {
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            // Close button top-right
            HStack {
                Spacer()
                Button {
                    onCancel()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.24))
                        .overlay(
                            Circle()
                                .stroke(Color.lightBlueBorderColor, lineWidth: 1)
                        )
                        .clipShape(Circle())
                }
            }

            // Stop animation
            LottieSwiftUIView(animationName: "stop")
                .frame(width: 100, height: 100)

            // Title + subtitle
            VStack(spacing: 6) {
                Text("Confirm cancel subscription".localized)
                    .expoSystemFont(size: FontSize.large, weight: .medium)
                    .foregroundColor(.darkTextColor)
                    .multilineTextAlignment(.center)

                Text("This action cannot be undone".localized)
                    .expoSystemFont(size: FontSize.small, weight: .regular)
                    .foregroundColor(.subtitleTextColor)
                    .multilineTextAlignment(.center)
            }

            // Buttons row
            HStack(spacing: 8) {
                PlainTextButton(title: "Cancel".localized) {
                    onCancel()
                }
                .frame(width: 171)

                RedFilledPillButton(title: "Confirm cancellation".localized) {
                    onConfirm()
                }
                .frame(width: 171)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(MainGradientView())
        .logViewAppearance()
    }
}

#Preview {
    CancelSubscriptionConfirmationView(
        onConfirm: {},
        onCancel: {}
    )
}
