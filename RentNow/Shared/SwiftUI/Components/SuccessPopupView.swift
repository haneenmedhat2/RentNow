//
//  SuccessPopupView.swift
//  HoloolProvider
//
//  Created by Elshamy on 05/01/2026.
//

import SwiftUI
import Lottie

struct SuccessPopupView: View {
    let message: String
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                GifImageView(name: "sucess")
                    .frame(width: 150, height: 150)
                
                // Success message
                Text(message)
                    .expoSystemFont(size: FontSize.large, weight: .medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            
        }
        .onAppear {
            // Auto-dismiss after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    isPresented = false
                }
            }
        }
    }

}

// View modifier for easy usage
extension View {
    func successPopup(message: String, isPresented: Binding<Bool>) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                SuccessPopupView(message: message, isPresented: isPresented)
                    .transition(.opacity)
                    .zIndex(999)
            }
        }
    }
}
