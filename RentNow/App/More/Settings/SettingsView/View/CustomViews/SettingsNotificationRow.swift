//
//  SettingsNotificationRow.swift
//  RentNow
//

import SwiftUI

struct SettingsNotificationRow: View {
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 6) {
            Image("Shape")
                .scaledToFill()
                .frame(width: 24, height: 24)

            Text("Notifications".localized)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.black)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.green)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .glassyBackground(cornerRadius: 4)
    }
}

#Preview {
    ZStack {
        MainGradientView()
            .ignoresSafeArea()
        SettingsNotificationRow(isOn: .constant(true))
            .padding(.horizontal, 16)
    }
}
