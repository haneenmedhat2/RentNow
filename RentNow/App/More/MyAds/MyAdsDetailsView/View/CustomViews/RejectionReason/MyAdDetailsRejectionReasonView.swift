//
//  MyAdDetailsRejectionReasonView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct MyAdDetailsRejectionReasonView: View {

    let reason: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Rejection Reason".localized)
                .expoSystemFont(size: FontSize.normal, weight: .bold)
                .foregroundColor(.black)

            Text(reason)
                .expoSystemFont(size: FontSize.normal, weight: .regular)
                .foregroundColor(.black.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .glassyBackground(cornerRadius: 8)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

#Preview {
    MyAdDetailsRejectionReasonView(reason: "الصور غير واضحة")
}
