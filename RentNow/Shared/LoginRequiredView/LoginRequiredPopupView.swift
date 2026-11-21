//
//  LoginRequiredPopupView.swift
//  RentNow
//
//  Created by Claude on 2026-03-23.
//

import SwiftUI

struct LoginRequiredPopupView: View {
    let onLogin: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            // Lock Icon
            Image(systemName: "lock.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.mainColor)

            // Title
            Text("Login Required".localized)
                .expoSystemFont(size: FontSize.large, weight: .bold)
                .foregroundColor(.black)

            // Message
            Text("Please login to access this feature".localized)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.black.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)

            // Buttons
            HStack(spacing: 12) {
                Button(action: onCancel) {
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

                Button(action: onLogin) {
                    Text("Login".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            Color(.main)
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
    }
}

#Preview {
    LoginRequiredPopupView(
        onLogin: {},
        onCancel: {}
    )
}
