//
//  MoreMenuItemView.swift
//  RentNow
//
//  Created by Elshamy on 11/02/2026.
//

import SwiftUI

struct MoreMenuItemView: View {
    let icon: String
    let title: String
    var showChevron: Bool = true
    var onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 6) {
                Image(icon)
                    .frame(width: 24 ,height: 24)

                Text(title)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.black)

                Spacer()

                if showChevron {
                    Image(systemName: Language.isRTL() ? "chevron.left" : "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(.black.opacity(0.6))
                }
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
        MoreMenuItemView(
            icon: "person",
            title: "الملف الشخصي",
            onTap: {}
        )
        .padding(.horizontal, 16)
    }
}
