//
//  MainButton.swift
//  RentNow
//
//  Created by Elshamy on 01/02/2026.
//


import SwiftUI

struct GlassyButton: View {
    var title: String
    var image: String? = nil
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let image = image {
                    Image(image)
                        .resizable()
                        .frame(width: 20, height: 20)
                }

                Text(title)
                    .expoSystemFont(size: 18, weight: .bold)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .glassyBackground(cornerRadius: 16)
        }
        .padding(.horizontal, 16)
    }
}

