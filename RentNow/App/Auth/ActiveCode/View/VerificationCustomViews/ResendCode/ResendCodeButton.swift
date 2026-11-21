//
//  TermsAndConditionsButton.swift
//  Holool
//
//  Created by Elshamy on 11/11/2025.
//



import SwiftUI

struct ResendButton: View {
    var action: () -> Void

    var body: some View {
        HStack(spacing: 6) {
            // MARK: - Text
            Text("verification_resend_question".localized)
                .foregroundStyle(.black)
                .expoSystemFont(size: FontSize.normal, weight: .medium)

            Button(action: action) {
                Text("verification_resend_action".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundStyle(.main)
                    .underline()
            }

        }

    }
}

#Preview {
    ResendButton(action: {})
}
