//
//  ToastView.swift
//  Holool
//
//  Created by Elshamy on 03/11/2025.
//

import SwiftUI

struct ToastView: View {
    let message: String
    let type: ToastType
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: type.icon)
               .expoSystemFont(size: 18, weight: .medium)
                .foregroundColor(.white)
            
            Text(message)
               .expoSystemFont(size: 15, weight: .medium)
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(type.background)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 4)
        .padding(.horizontal, 16)
        .transition(
            .asymmetric(
                insertion: .move(edge: .top).combined(with: .opacity).combined(with: .scale(scale: 0.8)),
                removal: .move(edge: .top).combined(with: .opacity)
            )
        )
    }
}

#Preview {
    ToastView(message: "done", type: .success)
}


