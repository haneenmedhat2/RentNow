//
//  LoginRequiredView.swift
//  Holool
//
//  Created by Elshamy on 17/01/2026.
//

import SwiftUI

struct LoginRequiredView: View {
    var title: String
    var message: String
    var onLoginTap: () -> Void

    init(
        title: String = "Login Required".localized,
        message: String = "Please login to access this feature".localized,
        onLoginTap: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.onLoginTap = onLoginTap
    }

    var body: some View {
        ZStack {
            MainGradientView()
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                // Lock Icon
                Image(systemName: "lock.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white.opacity(0.8))

                // Title
                Text(title)
                    .expoSystemFont(size: FontSize.large, weight: .bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                // Message
                Text(message)
                    .expoSystemFont(size: FontSize.normal)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                // Login Button
                MainButton(title: "Login".localized) {
                    onLoginTap()
                }
                .padding(.horizontal, 48)
                .padding(.top, 16)

                Spacer()
            }
        }
    }
}

#Preview {
    LoginRequiredView {
        print("Login tapped")
    }
}
