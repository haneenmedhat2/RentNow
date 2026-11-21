//
//  VideoPlayerView.swift
//  Holool
//
//  Created by Elshamy on 22/12/2025.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    let videoURL: String
    let preloadedPlayer: AVPlayer?

    @Environment(\.dismiss) private var dismiss
    @State private var player: AVPlayer?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let player = player {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 60))
                        .foregroundColor(.white)

                    Text("Unable to load video".localized)
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                }
            }

            // Close Button
            VStack {
                HStack {
                    Spacer()

                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                            .padding()
                    }
                }

                Spacer()
            }
        }
        .onAppear {
            setupPlayer()
        }
        .onDisappear {
            player?.pause()
        }
    }

    private func setupPlayer() {
        if let preloadedPlayer = preloadedPlayer {
            print("🎬 Using preloaded player")
            self.player = preloadedPlayer

            // Start playing immediately
            preloadedPlayer.play()
            print("▶️ Started playing preloaded video")
        } else {
            guard let url = URL(string: videoURL) else {
                print("❌ Invalid video URL")
                return
            }

            print("🎬 Creating new player")
            let newPlayer = AVPlayer(url: url)
            self.player = newPlayer

            // Start playing
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                newPlayer.play()
                print("▶️ Started playing new video")
            }
        }
    }
}
