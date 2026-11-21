//
//  IntroHeaderView.swift
//  RentNow
//
//  Created by Claude on 22/01/2026.
//

import SwiftUI

struct IntroHeaderView: View {
    var onSkip: () -> Void

    var body: some View {
        VStack {
            HStack {
                // Logo 48x48
                Image("Logo")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)

                Spacer()

                // Skip button
                Button(action: onSkip) {
                    Text("Skip".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(.white)
                }
                .frame(width: 50 , height: 50)
                
            }
            .padding(.top, 67)
            .padding(.horizontal, 20)

            Spacer()
        }
    }
}
