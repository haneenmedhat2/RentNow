//
//  SplashView.swift
//  Holool
//
//  Created by Elshamy on 21/10/2025.
//
import SwiftUI

struct SplashView: View {

    @State private var animateSplashTop = false
    @State private var animateLogo = false
    @State private var animateSplaceBottom = false
    @State private var animateRentNowText = false

    var onFinish: (() -> Void)?

    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width

            ZStack {
                Color(.main)
                    .ignoresSafeArea()

                // splashTop - top-left, slides from left
                Image("splashTop")
                    .padding(.top, 40)

                    .offset(x: animateSplashTop ? 0 : -screenWidth)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .animation(.spring(response: 0.8, dampingFraction: 0.75), value: animateSplashTop)

                // Logo - center, slides from left
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: screenWidth - 64, height: 200)
                    .offset(x: animateLogo ? 0 : -screenWidth)
                    .animation(.spring(response: 0.8, dampingFraction: 0.75), value: animateLogo)

                // splaceBottom - bottom-right, slides from right
                Image("splaceBottom")
                    .padding(.bottom, 80)
                    .offset(x: animateSplaceBottom ? 0 : screenWidth)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .animation(.spring(response: 0.8, dampingFraction: 0.75), value: animateSplaceBottom)

                // Rent Now text - bottom center, slides from bottom
                VStack {
                    Spacer()
                    Text("Rent Now".localized)
                        .foregroundColor(.white)
                        .offset(y: animateRentNowText ? 0 : 100)
                        .opacity(animateRentNowText ? 1 : 0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.75), value: animateRentNowText)
                        .padding(.bottom, 10)
                }
            }
        }
        .onAppear {
            // Staggered animation timing
            withAnimation {
                animateSplashTop = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation {
                    animateLogo = true
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    animateSplaceBottom = true
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                withAnimation {
                    animateRentNowText = true
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                onFinish?()
            }
        }
        .environment(\.layoutDirection, .leftToRight)
        .logViewAppearance()
    }
}

#Preview {
    SplashView()
}
