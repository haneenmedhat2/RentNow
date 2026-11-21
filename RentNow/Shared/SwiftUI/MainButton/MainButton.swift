//
//  MainButton.swift
//  RentNow
//
//  Created by Elshamy on 04/11/2025.
//

import SwiftUI

struct MainButton: View {
    var title: String
    var image: String? = nil
    var backgroundColor: Color = Color(.main)
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
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .fill(backgroundColor)
            )
        }
        .padding(.horizontal, 16)
    }
}

