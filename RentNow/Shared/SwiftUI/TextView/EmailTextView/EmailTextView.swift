//
//  GeneralEmailTextView.swift
//  Holool
//
//  Created by Elshamy on 09/11/2025.
//

import SwiftUI

struct EmailTextView: View {

    @Binding var emailText: String
    @Binding var emailError: String?
    @Binding var hasEditedText: Bool
    var isOptional: Bool

    // Backward compatibility: when true, shows error without checking hasEditedText
    var showErrorAlways: Bool = false

    private var shouldShowError: Bool {
        if showErrorAlways {
            return emailError != nil
        } else {
            return hasEditedText && emailError != nil
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing:2) {
                Text("E-mail".localized)
               .expoSystemFont(size:FontSize.normal , weight: .medium)
                if isOptional {
                    Text("(Optional)".localized)
                       .expoSystemFont(size:FontSize.normal , weight: .medium)
                        .foregroundStyle(.secondaryDarkFont)
                }
            }
         
            
            VStack(spacing:0) {
                
                HStack(spacing: 8) {
                   Image("email")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .scaledToFit()
                    FixedTextField(
                        placeholder: "E-mail".localized,
                        keyboardType: .emailAddress,
                        text: $emailText
                    )

                }
                .padding()
                .frame(height: 50)
                .glassyBackground(cornerRadius: 12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(
                    shouldShowError ? Color.red : Color.clear,
                    lineWidth: 0.7
                ))

                if shouldShowError {
                    HStack {
                        Text(emailError ?? "")
                           .expoSystemFont(size: FontSize.normal, weight: .medium)
                            .foregroundColor(.red)
                            .padding(8)
                        Spacer()
                    }
                }

            }
        }
        .padding(.horizontal, 16)
    }
}
#Preview {
    EmailTextView(emailText: .constant(""), emailError: .constant(""), hasEditedText: .constant(false), isOptional: true)
}
