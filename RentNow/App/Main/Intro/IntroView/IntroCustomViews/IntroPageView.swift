//
//  IntroPageView.swift
//  RentNow
//
//  Created by Claude on 22/01/2026.
//

import SwiftUI

struct IntroPageView: View {
    let splashScreen: SplashScreenModel

    var body: some View {
        ZStack {
            // Background Image
            RemoteImageView(url: splashScreen.imageUrl)
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .clipped()

            // Dark overlay
            Color.black.opacity(0.32)

            // Bottom gradient overlay
            VStack {
                Spacer()
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color(red: 6/255, green: 50/255, blue: 109/255).opacity(0.48)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: UIScreen.main.bounds.height * 0.5)
            }

            // Content (Title + Description)
            VStack {
                Spacer()

                VStack(alignment: .leading, spacing: 8) {
                    Text(splashScreen.title)
                        .expoSystemFont(size: 24, weight: .bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)

                    if let description = splashScreen.description, !description.isEmpty {
                        Text(description)
                            .expoSystemFont(size: 14, weight: .regular)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.leading)
                            .lineSpacing(4)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 140)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .ignoresSafeArea()
    }
}
