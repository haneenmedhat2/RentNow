//
//  GifImageView.swift
//  RentNow
//
//  Created by Claude on 25/01/2026.
//

import SwiftUI
import UIKit

struct GifImageView: UIViewRepresentable {
    let name: String

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        if let gifImage = UIImage.gifImageWithName(name) {
            imageView.image = gifImage
        }

        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        // No updates needed
    }
}
