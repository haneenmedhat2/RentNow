//
//  ImageGalleryView.swift
//  Holool
//
//  Created by Elshamy on 22/12/2025.
//

import SwiftUI

struct ImageGalleryView: View {
    let images: [String]
    let selectedIndex: Int

    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex: Int

    init(images: [String], selectedIndex: Int) {
        self.images = images
        self.selectedIndex = selectedIndex
        _currentIndex = State(initialValue: selectedIndex)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            TabView(selection: $currentIndex) {
                ForEach(images.indices, id: \.self) { index in
                    AsyncImage(url: URL(string: images[index])) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                        case .failure(_), .empty:
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    Image(systemName: "photo")
                                        .font(.system(size: 60))
                                        .foregroundColor(.white.opacity(0.5))
                                )
                        @unknown default:
                            ProgressView()
                                .tint(.white)
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))

            VStack {
                HStack {
                    Spacer()

                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding()
                    }
                }

                Spacer()
            }
        }
    }
}
