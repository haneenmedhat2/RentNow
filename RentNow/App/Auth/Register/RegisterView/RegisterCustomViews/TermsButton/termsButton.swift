
//
//  TermsAndConditionsButton.swift
//  Holool
//
//  Created by Elshamy on 10/11/2025.
//

import SwiftUI

struct TermsAndConditionsButton: View {
    @Binding var isChecked: Bool
    var agreeError: String?
    var action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 6) {
                // MARK: - Checkbox
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.main)
                    .onTapGesture {
                        isChecked.toggle()
                    }

                // MARK: - Text
                Text("Agree to".localized)
                    .foregroundStyle(.black)
                   .expoSystemFont(size: FontSize.normal, weight: .medium)

                Button(action: action) {
                    Text("Terms and Conditions".localized)
                       .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundStyle(.main)
                        .underline()
                }

                Spacer()
            }

            // MARK: - Agree Error
            if let agreeError = agreeError {
                HStack {
                    Text(agreeError)
                        .expoSystemFont(size: FontSize.small, weight: .medium)
                        .foregroundColor(.red)
                        .padding(.top, 4)
                        .padding(.leading , 20)
                    Spacer()
                }
            }
        }
        .padding([.leading , .trailing ], 16)
        .padding(.bottom , 8)
    }
}

#Preview {
    TermsAndConditionsButton(isChecked: .constant(true), agreeError: nil, action: {})
}
