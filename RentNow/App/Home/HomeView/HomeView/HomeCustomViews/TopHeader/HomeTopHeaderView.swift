//
//  HomeTopHeaderView.swift
//  RentNow
//
//  Created by Elshamy on 25/01/2026.
//

import SwiftUI

struct HomeTopHeaderView: View {
    let userAddress: String
    var isVisitor: Bool = false
    var onLocationTap: () -> Void

    var body: some View {
        HStack {
            if !isVisitor {
                // Location Picker Button
                Button {
                    onLocationTap()
                } label: {
                    HStack(spacing: 6) {
                        Text(userAddress)
                            .expoSystemFont(size: FontSize.small, weight: .medium)
                            .foregroundColor(.black)
                            .lineLimit(1)

                        Image(systemName: "location.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.mainColor)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .glassyBackground()
                }
            }

            Spacer()

            // Logo
            Image("Logo")
                .resizable()
                .scaledToFill()
                .frame(width: 100,height: 100)
        }
    }
}

#Preview {
    HomeTopHeaderView(userAddress: "الرياض", onLocationTap: {})
}
