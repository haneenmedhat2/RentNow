//
//  NafathVerificationPopupView.swift
//  RentNow
//

import SwiftUI

struct NafathVerificationPopupView: View {

    enum VerificationState {
        case authenticating
        case success
    }

    @State private var state: VerificationState = .authenticating
    var onComplete: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            // Animation area
            Group {
                switch state {
                case .authenticating:
                    PulsatingDotsView()
                        .frame(width: 150, height: 150)
                case .success:
                    GifImageView(name: "sucess")
                        .frame(width: 150, height: 150)
                }
            }

            Text(titleText)
                .expoSystemFont(size: FontSize.large, weight: .medium)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text(subtitleText)
                .expoSystemFont(size: 11, weight: .regular)
                .foregroundColor(Color(hex: "#DEDEDE"))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 48)
        .padding(.vertical, 24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "#2C2C2C"))
        )
        .padding(.horizontal, 32)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    state = .success
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    onComplete()
                }
            }
        }
    }

    private var titleText: String {
        switch state {
        case .authenticating:
            return "Authenticating via Nafath".localized
        case .success:
            return "Authentication Successful".localized
        }
    }

    private var subtitleText: String {
        switch state {
        case .authenticating:
            return "Please wait until authentication is completed".localized
        case .success:
            return "Please wait, you will be redirected to the home page".localized
        }
    }
}

// MARK: - Pulsating Dots Animation

private struct PulsatingDotsView: View {
    @State private var animating = false

    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(Color.white)
                    .frame(width: 16, height: 16)
                    .scaleEffect(animating ? 1.0 : 0.5)
                    .opacity(animating ? 1.0 : 0.4)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.2),
                        value: animating
                    )
            }
        }
        .onAppear {
            animating = true
        }
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.5).ignoresSafeArea()
        NafathVerificationPopupView(onComplete: {})
    }
}
