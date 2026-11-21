//
//  AppImagePickerView.swift
//  Holool
//
//  Created by Elshamy on 02/12/2025.
//

import SwiftUI
import PhotosUI
import AVFoundation
import QuickLook


struct AppImagePickerView: View {
    let title: String
    let mediaType: MediaType
    let maxCount: Int
    @Binding var mediaItems: [MediaItem]
    @Binding var mediaError: String?

    @State private var showingPHPicker = false
    @State private var showingCamera = false
    @State private var showingActionSheet = false
    @State private var showingLimitAlert = false
    @State private var previewURL: URL?
    @State private var showingQuickLook = false

    init(title: String,
         mediaType: MediaType = .photoOnly,
         maxCount: Int = 5,
         mediaItems: Binding<[MediaItem]>,
         mediaError: Binding<String?> = .constant(nil)) {
        self.title = title
        self.mediaType = mediaType
        self.maxCount = maxCount
        self._mediaItems = mediaItems
        self._mediaError = mediaError
    }
    
    var canAddMore: Bool {
        mediaItems.count < maxCount
    }
    
    var remainingCount: Int {
        maxCount - mediaItems.count
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Title
            HStack(spacing: 8) {
                Text(title)
                   .expoSystemFont(size:FontSize.normal , weight: .medium)
                Spacer()
            }
            
            // Container with unified background
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    // Add button
                    if canAddMore {
                        Button(action: {
                            guard !showingActionSheet, !showingPHPicker, !showingCamera else { return }
                            if remainingCount <= 0 {
                                showingLimitAlert = true
                            } else {
                                showingActionSheet = true
                            }
                        }) {
                            Image("selectImage")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                    }

                    // Selected media items
                    ForEach(mediaItems) { item in
                        ZStack(alignment: .topLeading) {
                            Button(action: {
                                if item.type == .photo {
                                    if let url = saveImageTemporarily(item.image) {
                                        previewURL = url
                                        showingQuickLook = true
                                    }
                                } else if let videoURL = item.videoURL {
                                    previewURL = videoURL
                                    showingQuickLook = true
                                }
                            }) {
                                ZStack {
                                    Image(uiImage: item.image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))

                                    // Play icon for videos
                                    if item.type == .video {
                                        Image(systemName: "play.circle.fill")
                                           .expoSystemFont(size: 28)
                                            .foregroundColor(.white)
                                            .shadow(color: .black.opacity(0.3), radius: 2)
                                    }
                                }
                            }
                            .contentShape(RoundedRectangle(cornerRadius: 8))

                            // Delete Button
                            Button(action: {
                                if let index = mediaItems.firstIndex(where: { $0.id == item.id }) {
                                    withAnimation {
                                        mediaItems.remove(at: index)
                                    }
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                   .expoSystemFont(size: 22)
                                    .foregroundColor(.red)
                                    .background(
                                        Circle()
                                            .fill(Color.white)
                                            .frame(width: 15, height: 15)
                                    )
                                    .padding(6)
                                    .contentShape(Rectangle())
                            }

                        }
                    }
                }
                .frame(minHeight: 50)
                .padding(12)
            }
//            .glassyBackground(cornerRadius: 12)
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(
                (mediaError != nil) ? Color.red : Color.clear,
                lineWidth: 0.7
            ))

            // Subtitle hint below container
           
            HStack(spacing: 8) {
                Text(subtitleText)
                    .expoSystemFont(size: FontSize.small, weight: .medium)
                    .foregroundColor(.gray)
                Spacer()
            }
            if mediaError != nil {
                HStack {
                    Text(mediaError ?? "")
                       .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(.red)
                        .padding(8)
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 16)
        .confirmationDialog("Choose Source".localized, isPresented: $showingActionSheet) {
            Button("Gallery".localized) {
                showingPHPicker = true
            }
            
            Button("Camera".localized) {
                showingCamera = true
            }
            
            Button("Cancel".localized, role: .cancel) {}
        }
        .sheet(isPresented: $showingPHPicker) {
            PHPickerMediaView(
                mediaType: mediaType,
                maxSelection: remainingCount,
                mediaItems: $mediaItems
            )
        }
        .fullScreenCover(isPresented: $showingCamera) {
            NativeCameraMediaView(
                mediaType: mediaType,
                mediaItems: $mediaItems
            )
            .ignoresSafeArea()

        }
        .sheet(isPresented: $showingQuickLook) {
            if let url = previewURL {
                QuickLookView(url: url)
            }
        }
        .alert("Maximum Limit Reached".localized, isPresented: $showingLimitAlert) {
            Button("OK".localized, role: .cancel) {}
        } message: {
            Text(String(format: "You have reached the maximum allowed: %d".localized, maxCount))
        }
    }
    
    // MARK: - Helper Functions
    
    private func saveImageTemporarily(_ image: UIImage) -> URL? {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = tempDirectory.appending(path: fileName)
        
        try? data.write(to: fileURL)
        return fileURL
    }
    
    private var subtitleText: String {
        switch mediaType {
        case .photoOnly:
            return String(format: "You can upload up to %d photos".localized, maxCount)
        case .videoOnly:
            return String(format: "You can upload up to %d videos".localized, maxCount)
        case .photoAndVideo:
            return String(format: "You can upload up to %d photos/videos".localized, maxCount)
        }
    }
}
