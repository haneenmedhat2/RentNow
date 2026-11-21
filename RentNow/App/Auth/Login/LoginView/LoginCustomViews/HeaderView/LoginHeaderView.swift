//
//  LoginHeaderView.swift
//  RentNow
//
//  Created by Elshamy on 03/11/2025.
//

import SwiftUI

struct LoginHeaderView: View {
    var onVisitorTap: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            // Logo
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)

            // Welcome text with emoji
            HStack {
                Text("Hello! Welcome back agian.".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .regular)
                    .foregroundColor(.black.opacity(0.7))
                
                Image("hello")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20 , height: 20)
                
            }

            // Title
            Text("Login".localized)
                .expoSystemFont(size: 28, weight: .bold)
                .foregroundColor(.black)

            // Subtitle
            Text("Sign in and let us help you rent or list your car easily.".localized)
                .expoSystemFont(size: FontSize.normal, weight: .regular)
                .foregroundColor(.black.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    LoginHeaderView(onVisitorTap: {})
}
