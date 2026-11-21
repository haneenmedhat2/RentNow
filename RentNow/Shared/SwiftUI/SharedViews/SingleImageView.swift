//
//  SingleImageView.swift
//  Holool
//
//  Created by Elshamy on 23/12/2025.
//

import SwiftUI
import Kingfisher

struct SingleImageView: View {
    let imageURL: String

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let url = URL(string: imageURL) {
                KFImage(url)
                    .cacheOriginalImage()
                    .fade(duration: 0.2)
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "photo")
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.5))
                    Text("Invalid image URL".localized)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                }
            }

            // Close Button
            VStack {
                HStack {
                    Spacer()

                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                            .padding()
                    }
                }

                Spacer()
            }
        }
    }
}
