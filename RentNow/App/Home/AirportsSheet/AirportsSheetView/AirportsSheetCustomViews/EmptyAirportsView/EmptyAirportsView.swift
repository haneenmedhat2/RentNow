//
//  EmptyAirportsView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct EmptyAirportsView: View {
    // MARK: - Properties
    var onOpenMap: () -> Void

    // MARK: - Body
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "airplane.departure")
                .font(.system(size: 50))
                .foregroundColor(.gray)

            Text("airports_empty_title".localized)
                .font(.system(size: FontSize.large, weight: .bold))
                .foregroundColor(.primary)

            Text("airports_empty_message".localized)
                .font(.system(size: FontSize.small, weight: .regular))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

            OutlineButton(
                title: "airports_determine_location".localized,
                action: onOpenMap
            )
            .padding(.top, 8)
        }
        .padding(32)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview
#Preview {
    EmptyAirportsView {
        print("Open map tapped")
    }
}
