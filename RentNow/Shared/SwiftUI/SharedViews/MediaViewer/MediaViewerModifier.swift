//
//  MediaViewerModifier.swift
//  Holool
//
//  Created by Elshamy on 23/12/2025.
//

import SwiftUI

struct MediaViewerModifier: ViewModifier {
    @ObservedObject var manager: MediaViewerManager

    func body(content: Content) -> some View {
        content
            .overlay {
                if manager.isLoading {
                    LoadingOverlayView(message: manager.loadingMessage)
                }
            }
            .sheet(isPresented: $manager.showSingleImage) {
                if !manager.selectedImageURL.isEmpty {
                    SingleImageView(imageURL: manager.selectedImageURL)
                        .onDisappear {
                            manager.resetImage()
                        }
                }
            }
            .sheet(isPresented: $manager.showVideoPlayer) {
                if let videoURL = manager.selectedVideoURL, let player = manager.preloadedPlayer {
                    VideoPlayerView(videoURL: videoURL, preloadedPlayer: player)
                        .onDisappear {
                            manager.resetVideo()
                        }
                }
            }
    }
}

extension View {
    func mediaViewer(_ manager: MediaViewerManager) -> some View {
        modifier(MediaViewerModifier(manager: manager))
    }
}
