//
//  NoInternetAlertView.swift
//  Holool
//
//  Created by Claude on 18/01/2026.
//

import SwiftUI

struct NoInternetAlertView: View {
    let onRetry: (() -> Void)?
    let onDismiss: () -> Void

    @State private var isPresented: Bool = false

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .allowsHitTesting(isPresented)

            // Alert dialog
            VStack(spacing: 24) {
                // No Internet Icon
                Image(systemName: "wifi.exclamationmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.red)

                // Title
                Text("No Internet Connection".localized)
                    .expoSystemFont(size: FontSize.large, weight: .bold)
                    .foregroundColor(.black)

                // Message
                Text("Please check your internet connection and try again".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                // Buttons
                HStack(spacing: 12) {
                    // Retry Button
                    if let onRetry = onRetry {
                        Button(action: {
                            handleDismiss()
                            onRetry()
                        }) {
                            Text("Retry".localized)
                                .expoSystemFont(size: FontSize.normal, weight: .medium)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(
                                    LinearGradient.mainGradient
                                        .cornerRadius(12)
                                )
                        }
                    }

                    // OK Button
                    Button(action: handleDismiss) {
                        Text("OK".localized)
                            .expoSystemFont(size: FontSize.normal, weight: .medium)
                            .foregroundColor(onRetry == nil ? .white : .mainColor)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                Group {
                                    if onRetry == nil {
                                        LinearGradient.mainGradient
                                            .cornerRadius(12)
                                    } else {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(Color.mainColor.opacity(0.3), lineWidth: 1)
                                            )
                                    }
                                }
                            )
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(red: 0.95, green: 0.95, blue: 0.95))
            )
            .padding(.horizontal, 32)
            .scaleEffect(isPresented ? 1 : 0.95)
            .opacity(isPresented ? 1 : 0)
            .animation(.easeOut(duration: 0.2), value: isPresented)
            .zIndex(1)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.2)) {
                isPresented = true
            }
        }
    }

    private func handleDismiss() {
        withAnimation(.easeIn(duration: 0.15)) {
            isPresented = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            onDismiss()
        }
    }
}

// MARK: - Preview
#Preview {
    NoInternetAlertView(
        onRetry: { print("Retry tapped") },
        onDismiss: { print("Dismissed") }
    )
}
