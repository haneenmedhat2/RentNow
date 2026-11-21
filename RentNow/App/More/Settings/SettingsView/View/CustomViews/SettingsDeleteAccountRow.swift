//
//  SettingsDeleteAccountRow.swift
//  RentNow
//

import SwiftUI

struct SettingsDeleteAccountRow: View {
    var onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 6) {
                Image("delete-03")
                    .scaledToFill()
                    .frame(width: 24, height: 24)

                Text("Delete Account".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.black)

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
        SettingsDeleteAccountRow(onTap: {})
            .padding(.horizontal, 16)
    }
}
