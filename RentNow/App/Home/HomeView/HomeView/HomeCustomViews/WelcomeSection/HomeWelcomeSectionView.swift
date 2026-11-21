//
//  HomeWelcomeSectionView.swift
//  RentNow
//
//  Created by Elshamy on 25/01/2026.
//

import SwiftUI
import UIKit

struct HomeWelcomeSectionView: View {
    let userName: String
    let userImage: UIImage?
    let userImageUrl: String?
    var onSearchTap: () -> Void
    var onNotificationTap: () -> Void

    var body: some View {
        HStack(alignment: .center) {
            // Welcome Text & Avatar
            HStack(spacing: 12) {
                // User Avatar
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .overlay {
                        if let imageUrl = userImageUrl {
                            RemoteImageView(url: imageUrl)
                                .scaledToFill()
                                .clipShape(Circle())
                        } else if let userImage = userImage {
                            Image(uiImage: userImage)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                        }
                    }
                
                VStack(alignment: .leading, spacing: 2) {
                    HStack{
                        Text("home_welcome_message".localized)
                            .expoSystemFont(size: FontSize.small, weight: .regular)
                            .foregroundColor(.black.opacity(0.7))
                        
                        Image("hello")
                            .resizable()
                            .frame(width: 15 , height: 15)
                            .scaledToFill()
                    }
                    
                    Text(userName)
                        .expoSystemFont(size: FontSize.normal, weight: .bold)
                        .foregroundColor(.main)
                }

              
            }
            
         

            Spacer()
            
            // Search & Notification Buttons
            HStack(spacing: 12) {
                // Notification Button
                Button {
                    onNotificationTap()
                } label: {
                    Image("notificationIcon")
                        .resizable()
                        .scaledToFill()
                    .frame(width: 44, height: 44)

                }

                // Search Button
                Button {
                    onSearchTap()
                } label: {
                    Image("searchIcon")
                        .resizable()
                        .scaledToFill()
                    .frame(width: 44, height: 44)

                }
            }

         
        }
    }
}

#Preview {
    HomeWelcomeSectionView(
        userName: "محمد",
        userImage: nil,
        userImageUrl: nil,
        onSearchTap: {},
        onNotificationTap: {}
    )
}
