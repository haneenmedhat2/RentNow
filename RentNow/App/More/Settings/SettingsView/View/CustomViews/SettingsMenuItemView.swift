//
//  SettingsMenuItemView.swift
//  RentNow
//

import SwiftUI

struct SettingsMenuItemView: View {
    let icon: String
    let title: String
    var iconColor: Color = .black
    var onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 6) {
                Image(icon)
                    .scaledToFill()
                    .frame(width: 24, height: 24)

                Text(title)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.black)

                Spacer()

                Image(systemName: Language.isRTL() ?  "chevron.left" : "chevron.right" )
                    .font(.system(size: 12))
                    .foregroundColor(.black.opacity(0.6))
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
        SettingsMenuItemView(
            icon: "person",
            title: "Edit Profile",
            onTap: {}
        )
        .padding(.horizontal, 16)
    }
}
