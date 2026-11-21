//
//  MyAdDetailsStatusToggleView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct MyAdDetailsStatusToggleView: View {

    let isAvailable: Bool
    var onToggle: () -> Void

    var body: some View {
        HStack {
            Text("Ad Status".localized)
                .expoSystemFont(size: FontSize.normal, weight: .bold)
                .foregroundColor(.black)

            Spacer()

            Text(isAvailable ? "Ad Active".localized : "Ad Inactive".localized)
                .expoSystemFont(size: FontSize.small, weight: .medium)
                .foregroundColor(.black)

            Toggle("", isOn: Binding(
                get: { isAvailable },
                set: { _ in onToggle() }
            ))
            .labelsHidden()
            .tint(.secoundGreen)
        }
        .padding(16)
        .glassyBackground(cornerRadius: 8)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

#Preview {
    MyAdDetailsStatusToggleView(
        isAvailable: true,
        onToggle: {}
    )
}
