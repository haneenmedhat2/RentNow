//
//  LoadingOverlayView.swift
//  Holool
//
//  Created by Elshamy on 23/12/2025.
//

import SwiftUI

struct LoadingOverlayView: View {
    let message: String

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.8))
            )
        }
    }
}
