//
//  ProfileImagePickerView.swift
//  RentNow
//
//  Created by Apple on 24/01/2026.
//

import SwiftUI

// MARK: - Profile Image Picker View
struct ProfileImagePickerView: View {
    @Binding var mediaItems: [MediaItem]
    @Binding var imageData: Data?

    @State private var showingActionSheet = false
    @State private var showingPHPicker = false
    @State private var showingCamera = false

    var body: some View {
        VStack(spacing: 12) {
            // Profile image circle
            Button(action: {
                showingActionSheet = true
            }) {
                ZStack {
                    if let firstItem = mediaItems.first {
                        Image(uiImage: firstItem.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else {
                        Image("Avatar")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 80, height: 80)
                            .scaledToFill()
                    }
                }
            }

            Text("profile_photo_optional".localized)
                .expoSystemFont(size: FontSize.normal, weight: .regular)
                .foregroundColor(.black.opacity(0.7))
        }
        .confirmationDialog("Choose Source".localized, isPresented: $showingActionSheet) {
            Button("Gallery".localized) {
                showingPHPicker = true
            }
            Button("Camera".localized) {
                showingCamera = true
            }
            if !mediaItems.isEmpty {
                Button("Remove photo".localized, role: .destructive) {
                    mediaItems.removeAll()
                    imageData = nil
                }
            }
            Button("Cancel".localized, role: .cancel) {}
        }
        .sheet(isPresented: $showingPHPicker) {
            PHPickerMediaView(
                mediaType: .photoOnly,
                maxSelection: 1,
                mediaItems: $mediaItems
            )
        }
        .fullScreenCover(isPresented: $showingCamera) {
            NativeCameraMediaView(
                mediaType: .photoOnly,
                mediaItems: $mediaItems
            )
            .ignoresSafeArea()
        }
        .onChange(of: mediaItems) { items in
            if let firstItem = items.first {
                imageData = firstItem.image.jpegData(compressionQuality: 0.8)
            } else {
                imageData = nil
            }
        }
    }
}
