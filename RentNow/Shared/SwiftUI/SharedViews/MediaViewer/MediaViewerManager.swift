//
//  MediaViewerManager.swift
//  Holool
//
//  Created by Elshamy on 23/12/2025.
//

import SwiftUI
import Kingfisher
import AVKit
import Combine

class MediaViewerManager: ObservableObject {
    // MARK: - Published Properties
    @Published var selectedImageURL: String = ""
    @Published var showSingleImage: Bool = false
    @Published var selectedVideoURL: String? = nil
    @Published var preloadedPlayer: AVPlayer? = nil
    @Published var showVideoPlayer: Bool = false
    @Published var isLoadingImage: Bool = false
    @Published var isLoadingVideo: Bool = false

    weak var viewModel: BaseViewModel?

    init(viewModel: BaseViewModel? = nil) {
        self.viewModel = viewModel
    }

    // MARK: - Image Prefetching
    func prefetchAndShowImage(_ imageURL: String) {
        guard let url = URL(string: imageURL) else {
            print("❌ Invalid URL: \(imageURL)")
            return
        }

        print("🔄 Starting to prefetch image: \(imageURL)")
        isLoadingImage = true

        // Use Kingfisher to prefetch the image
        let prefetcher = ImagePrefetcher(urls: [url]) { skippedResources, failedResources, completedResources in
            DispatchQueue.main.async {
                self.isLoadingImage = false

                if !failedResources.isEmpty {
                    print("❌ Failed to load image: \(failedResources)")
                    self.viewModel?.showError("Failed to load image".localized)
                } else {
                    print("✅ Image loaded successfully, showing sheet")
                    self.selectedImageURL = imageURL
                    self.showSingleImage = true
                }
            }
        }

        prefetcher.start()
    }

    // MARK: - Video Preloading
    func preloadAndShowVideo(_ videoURL: String) {
        guard let url = URL(string: videoURL) else {
            print("❌ Invalid video URL: \(videoURL)")
            viewModel?.showError("Invalid video URL".localized)
            return
        }

        print("🔄 Starting to preload video: \(videoURL)")
        isLoadingVideo = true

        let playerItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playerItem)

        // Observe player item status
        var cancellable: AnyCancellable?

        cancellable = playerItem.publisher(for: \.status)
            .sink { [weak self] status in
                guard let self = self else { return }

                switch status {
                case .readyToPlay:
                    print("✅ Video ready to play, showing player")
                    cancellable?.cancel()

                    DispatchQueue.main.async {
                        self.isLoadingVideo = false
                        self.preloadedPlayer = player
                        self.selectedVideoURL = videoURL
                        self.showVideoPlayer = true
                    }

                case .failed:
                    print("❌ Failed to load video: \(playerItem.error?.localizedDescription ?? "Unknown error")")
                    cancellable?.cancel()

                    DispatchQueue.main.async {
                        self.isLoadingVideo = false
                        self.viewModel?.showError("Failed to load video".localized)
                    }

                default:
                    break
                }
            }
    }

    // MARK: - Cleanup
    func resetImage() {
        selectedImageURL = ""
    }

    func resetVideo() {
        selectedVideoURL = nil
        preloadedPlayer = nil
    }

    var isLoading: Bool {
        isLoadingImage || isLoadingVideo
    }

    var loadingMessage: String {
        isLoadingImage ? "Loading image...".localized : "Loading video...".localized
    }
}
