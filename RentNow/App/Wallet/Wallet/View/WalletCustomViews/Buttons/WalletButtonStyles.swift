//
//  WalletButtonStyles.swift
//  RentNow
//
//  Created by Claude on 2026-03-23.
//

import SwiftUI

// MARK: - Dark Blue Pill Button (Subscribe / CTA)
struct DarkBluePillButton: View {
    let title: String
    var height: CGFloat = 44
    var fontSize: CGFloat = FontSize.large
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .expoSystemFont(size: fontSize, weight: .medium)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(Color(hex: "#022a60"))
                .clipShape(Capsule())
        }
    }
}

// MARK: - Gray Pill Button (Secondary action)
struct GrayPillButton: View {
    let title: String
    var height: CGFloat = 44
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .expoSystemFont(size: FontSize.large, weight: .medium)
                .foregroundColor(Color(hex: "#161616"))
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(Color(hex: "#f3f4f6"))
                .clipShape(Capsule())
        }
    }
}

// MARK: - Red Outline Pill Button (Destructive secondary)
struct RedOutlinePillButton: View {
    let title: String
    var height: CGFloat = 44
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .expoSystemFont(size: FontSize.large, weight: .medium)
                .foregroundColor(Color(hex: "#d92d20"))
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .overlay(
                    Capsule()
                        .stroke(Color(hex: "#f97066"), lineWidth: 1)
                )
        }
    }
}

// MARK: - Red Filled Pill Button (Destructive primary)
struct RedFilledPillButton: View {
    let title: String
    var height: CGFloat = 44
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .expoSystemFont(size: FontSize.large, weight: .medium)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: height)
                .background(Color(hex: "#d92d20"))
                .clipShape(Capsule())
        }
    }
}

// MARK: - Text Only Button (Plain)
struct PlainTextButton: View {
    let title: String
    var height: CGFloat = 44
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .expoSystemFont(size: FontSize.large, weight: .medium)
                .foregroundColor(Color(hex: "#161616"))
                .frame(maxWidth: .infinity)
                .frame(height: height)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        DarkBluePillButton(title: "Subscribe to a package") {}
        GrayPillButton(title: "Renew subscription") {}
        RedOutlinePillButton(title: "Cancel subscription") {}
        RedFilledPillButton(title: "Confirm cancellation") {}
        PlainTextButton(title: "Cancel") {}
    }
    .padding()
}
