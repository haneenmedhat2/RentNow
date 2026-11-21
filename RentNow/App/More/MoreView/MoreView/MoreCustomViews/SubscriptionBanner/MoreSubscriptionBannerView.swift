//
//  MoreSubscriptionBannerView.swift
//  RentNow
//
//  Created by Elshamy on 11/02/2026.
//

import SwiftUI

struct MoreSubscriptionBannerView: View {
    let packageName: String
    var onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 6) {
                Image("star-award-02")
                    .frame(width: 30 , height: 30)
                    .scaledToFit()

                Text("You are subscribed to".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .regular)
                    .foregroundColor(.black)

                Text(packageName)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.main)
                    .underline()

                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .glassyBackground(cornerRadius: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color(red: 220/255, green: 202/255, blue: 120/255).opacity(0.4), lineWidth: 1)
            )
        }
    }
}

