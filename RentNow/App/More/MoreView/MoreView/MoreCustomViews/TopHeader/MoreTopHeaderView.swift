//
//  MoreTopHeaderView.swift
//  RentNow
//
//  Created by Elshamy on 11/02/2026.
//

import SwiftUI

struct MoreTopHeaderView: View {
    let userName: String
    let userImage: String
    var isVisitor: Bool = false
    var onSettingsTap: () -> Void

    var body: some View {
        HStack {
            if isVisitor {
                // Visitor: Settings button + Logo
                Button {
                    onSettingsTap()
                } label: {
                    Image("settings")
                        .scaledToFill()
                        .frame(width: 38, height: 38)
                }

                Spacer()

                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 48)
            } else {
                // Logged in: User Info
                HStack(spacing: 8) {
                    RemoteImageView(url: userImage)
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            Text("Welcome back!".localized)
                                .expoSystemFont(size: FontSize.normal, weight: .regular)
                                .foregroundColor(.black.opacity(0.8))
                            Image("hello")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                            
                        }
                        HStack(spacing: 4) {
                            Text(userName)
                                .expoSystemFont(size: FontSize.large, weight: .bold)
                                .foregroundColor(.black)
                            Spacer()
                        }
                    }
                }

                Spacer()

                Button {
                    onSettingsTap()
                } label: {
                    Image("settings")
                        .scaledToFill()
                        .frame(width: 38, height: 38)
                }
            }
        }
    }
}

#Preview {
    ZStack {
        MainGradientView()
            .ignoresSafeArea()
        MoreTopHeaderView(
            userName: "محمد",
            userImage: "",
            onSettingsTap: {}
        )
        .padding(.horizontal, 16)
    }
}
