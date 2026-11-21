//
//  RemoteImageView.swift
//  Holool
//
//  Created by Elshamy on 19/11/2025.
//

import SwiftUI
import Kingfisher

struct RemoteImageView: View {
    let url: String?

    var body: some View {
        Group {
            if let urlString = url,
               !urlString.isEmpty,
               let normalized = normalizeToHTTPS(urlString),
               let imageURL = URL(string: normalized) {

                KFImage.url(imageURL)
                    .placeholder {
                        Rectangle()
                            .fill(Color.white.opacity(0.2))
                            .overlay { ProgressView() }
                    }
                    .resizable()

            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
            }
        }
        .clipped()
    }

    // MARK: - Normalize URL to HTTPS for specific host(s)
    // نحول أي رابط يبدأ بـ "http://dashboard.holool-sa.net" إلى "https://dashboard.holool-sa.net"
    // ونترك باقي الروابط كما هي (https يمر، و http من دومينات أخرى سيظل محظور وهذا آمن).
    private func normalizeToHTTPS(_ raw: String) -> String? {
        // Trim spaces/newlines
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        // Already https
        if trimmed.lowercased().hasPrefix("https://") {
            return trimmed
        }

        // Convert any http to https to avoid ATS blocking
        if trimmed.lowercased().hasPrefix("http://") {
            return trimmed.replacingOccurrences(of: "^http://", with: "https://", options: .regularExpression)
        }

        return trimmed
    }
}

// MARK: - Preview
#Preview {
    RemoteImageView(url: "https://mawruth-app.com/public/storage/images/images/1706800950_3259.jpg")
        .frame(height: 200)
        .cornerRadius(16)
        .padding()
}
