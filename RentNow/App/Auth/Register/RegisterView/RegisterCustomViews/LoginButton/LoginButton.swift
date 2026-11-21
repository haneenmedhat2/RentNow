//
//  LoginButton.swift
//  Holool
//
//  Created by Elshamy on 10/11/2025.
//
import SwiftUI

struct LoginButton: View {
    var action: () -> Void
    

    var body: some View {
        HStack(spacing:4) {
            Text("Do you have an account?".localized)
                .foregroundStyle(.white)
                .expoSystemFont(size: FontSize.large, weight: .medium)
            Button(action: action){
                Text("Login".localized)
                   .expoSystemFont(size: FontSize.large, weight: .medium)
                    .foregroundStyle(.main)
            }
        }
        .padding(.bottom , 16)
    }
}

#Preview {
    RegisterButton(action: {})
}
