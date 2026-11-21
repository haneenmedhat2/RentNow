//
//  RegisterButton.swift
//  RentNow
//
//  Created by Elshamy on 05/11/2025.
//

import SwiftUI

struct RegisterButton: View {
    var action: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text("Don't have an account?".localized)
                .expoSystemFont(size: FontSize.normal, weight: .regular)
                .foregroundColor(.black.opacity(0.6))

            Button(action: action) {
                Text("Create new account".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.main)
            }
        }
        .padding(.bottom, 24)
    }
}

#Preview {
    RegisterButton(action: {})
}
