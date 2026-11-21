//
//  MoreLogoutButtonView.swift
//  RentNow
//
//  Created by Elshamy on 11/02/2026.
//

import SwiftUI

struct MoreLogoutButtonView: View {
    var onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 6) {
                Spacer()
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.system(size: 16))
                    .foregroundColor(.red)
                Text("Logout".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.red)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .glassyBackground(cornerRadius: 4)
        }
    }
}

#Preview {
    ZStack {
        MainGradientView()
            .ignoresSafeArea()
        MoreLogoutButtonView(onTap: {})
            .padding(.horizontal, 16)
    }
}
