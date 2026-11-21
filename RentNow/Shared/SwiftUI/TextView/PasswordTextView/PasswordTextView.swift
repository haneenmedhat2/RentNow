//
//  PasswordTextView.swift
//  RentNow
//
//  Created by Elshamy on 04/11/2025.
//

import SwiftUI

struct PasswordTextView: View {
    var title: String
    @Binding var password: String
    @Binding var passwordError: String?
    @Binding var hasEditedPassword: Bool
    @State private var isSecure: Bool = true

    var showErrorAlways: Bool = false
    var isRequired: Bool = false

    private var shouldShowError: Bool {
        if showErrorAlways {
            return passwordError != nil
        } else {
            return hasEditedPassword && passwordError != nil
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Label with required indicator
            HStack(spacing: 4) {
                Text(title)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.black)

                if isRequired {
                    Text("*")
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(.red)
                }
            }

            // Password field
            HStack(spacing: 12) {
             

                // Password input
                if isSecure {
                    FixedSecureField(
                        placeholder: title,
                        text: $password
                    )
                    .onChange(of: password) { newValue in
                        hasEditedPassword = !newValue.trimmingCharacters(in: .whitespaces).isEmpty
                    }
                } else {
                    FixedTextField(
                        placeholder: title,
                        keyboardType: .default,
                        text: $password
                    )
                    .onChange(of: password) { newValue in
                        hasEditedPassword = !newValue.trimmingCharacters(in: .whitespaces).isEmpty
                    }
                }
                
                Spacer()
                
                // Eye button (leading)
                Button(action: {
                    withAnimation {
                        isSecure.toggle()
                    }
                }) {
                    Image(systemName: isSecure ? "eye" : "eye.slash")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 56)
            .glassyBackground(cornerRadius: 12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(shouldShowError ? Color.red : Color.clear, lineWidth: 1)
            )

            // Error message
            if shouldShowError {
                Text(passwordError ?? "")
                    .expoSystemFont(size: FontSize.small, weight: .regular)
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal, 16)
    }
}
