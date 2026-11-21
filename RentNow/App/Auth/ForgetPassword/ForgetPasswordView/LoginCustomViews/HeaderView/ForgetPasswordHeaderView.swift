//
//  ForgetPasswordHeaderView.swift
//  RentNow
//
//  Created by Elshamy on 03/11/2025.
//

import SwiftUI

struct ForgetPasswordHeaderView: View {

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title with emoji
            HStack(spacing: 8) {
                Text("forget_password_title".localized)
                    .expoSystemFont(size: 20, weight: .bold)
                    .foregroundColor(.main)

                Image("perfect")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 24, height: 24)
            }

            // Subtitle
            Text("forget_password_subtitle".localized)
                .expoSystemFont(size: FontSize.normal, weight: .regular)
                .foregroundColor(Color.black.opacity(0.6))
                .lineSpacing(4)
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

