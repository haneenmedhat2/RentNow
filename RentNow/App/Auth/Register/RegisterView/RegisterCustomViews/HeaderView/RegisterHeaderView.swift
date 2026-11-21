//
//  RegisterHeaderView.swift
//  Holool
//
//  Created by Elshamy on 03/11/2025.
//

import SwiftUI

struct RegisterHeaderView: View {

    var body: some View {
        VStack(spacing: 16) {
            // Logo
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)

            // Welcome text with car emoji
            HStack(spacing: 4) {
                Text("Let's begin your journey with".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .regular)
                
                Text("\"rent now\"".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .regular)
                    .foregroundColor(.blue)
                Text("🚗")
                    .font(.system(size: 18))
            }

            // Title
            Text("register_title".localized)
                .expoSystemFont(size: 24, weight: .bold)
                .foregroundColor(.main)

            // Subtitle
            Text("register_subtitle".localized)
                .expoSystemFont(size: FontSize.normal, weight: .regular)
                .foregroundColor(.black.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    RegisterHeaderView()
}
