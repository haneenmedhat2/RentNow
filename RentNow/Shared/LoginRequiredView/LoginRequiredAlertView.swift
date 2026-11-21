//
//  LoginRequiredAlertView.swift
//  Holool
//
//  Created by Elshamy on 17/01/2026.
//

import SwiftUI

struct LoginRequiredAlertView: View {
    let title: String
    let message: String
    let onLogin: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var isPresented: Bool = false

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .allowsHitTesting(isPresented)
                .onTapGesture {
                    handleDismiss()
                }

            // Alert dialog
            VStack(spacing: 24) {
                // Lock Icon
                Image(systemName: "lock.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.mainColor)

                // Title
                Text(title)
                    .expoSystemFont(size: FontSize.large, weight: .bold)
                    .foregroundColor(.black)

                // Message
                Text(message)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                // Buttons
                HStack(spacing: 12) {
                    // Cancel Button
                    Button(action: handleDismiss) {
                        Text("Cancel".localized)
                            .expoSystemFont(size: FontSize.normal, weight: .medium)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }

                    // Login Button
                    Button(action: handleLogin) {
                        Text("Login".localized)
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
                .padding(.horizontal, 16)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(red: 0.75, green: 0.75, blue: 0.75))
            )
            .padding(.horizontal, 32)
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
            .animation(.easeOut(duration: 0.2), value: isPresented)
            .zIndex(1)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.2)) {
                isPresented = true
            }
        }
    }

    private func handleLogin() {
        withAnimation(.easeIn(duration: 0.15)) {
            isPresented = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            dismiss()
            onLogin()
        }
    }

    private func handleDismiss() {
        withAnimation(.easeIn(duration: 0.15)) {
            isPresented = false
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            dismiss()
        }
    }
}

// MARK: - Preview
#Preview {
    LoginRequiredAlertView(
        title: "Login Required",
        message: "Please login to complete your purchase",
        onLogin: { print("Login tapped") }
    )
}
