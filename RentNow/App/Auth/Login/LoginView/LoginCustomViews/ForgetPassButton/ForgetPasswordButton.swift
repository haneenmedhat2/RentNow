//
//  ForgetPasswordButton.swift
//  RentNow
//
//  Created by Elshamy on 04/11/2025.
//

import SwiftUI

struct ForgetPasswordButton: View {
    var action: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Button(action: action) {
                Text("Forgot Password ?".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.main)
            }
           
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    ForgetPasswordButton(action: {})
}
