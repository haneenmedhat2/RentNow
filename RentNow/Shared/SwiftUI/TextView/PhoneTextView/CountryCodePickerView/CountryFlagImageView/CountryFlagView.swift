//
//  CountryCodePickerView.swift
//  Holool
//
//  Created by Elshamy on 04/11/2025.
//

import SwiftUI
import SVGKit

// MARK: - SVG Cache
final class SVGImageCache {
    static let shared = SVGImageCache()
    private var cache = NSCache<NSString, UIImage>()

    private init() {
        cache.countLimit = 300
    }

    func image(for url: String) -> UIImage? {
        cache.object(forKey: url as NSString)
    }

    func store(_ image: UIImage, for url: String) {
        cache.setObject(image, forKey: url as NSString)
    }

    func preload(urls: [String]) {
        for urlString in urls {
            guard urlString.lowercased().contains(".svg"),
                  image(for: urlString) == nil,
                  let url = URL(string: urlString) else { continue }

            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data,
                      let svgParsed = SVGKImage(data: data),
                      let uiImage = svgParsed.uiImage else { return }
                self.store(uiImage, for: urlString)
            }.resume()
        }
    }
}

// MARK: - Country Flag View
struct CountryFlagView: View {
    let imagePath: String?
    @State private var svgImage: UIImage?

    private var isSVG: Bool {
        guard let path = imagePath?.lowercased() else { return false }
        return path.contains(".svg")
    }

    var body: some View {
        if isSVG {
            Group {
                if let image = svgImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Color.clear
                }
            }
            .task(id: imagePath) {
                svgImage = nil
                guard let urlString = imagePath,
                      let url = URL(string: urlString) else { return }

                if let cached = SVGImageCache.shared.image(for: urlString) {
                    svgImage = cached
                    return
                }

                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    guard let svgParsed = SVGKImage(data: data),
                          let uiImage = svgParsed.uiImage else { return }
                    SVGImageCache.shared.store(uiImage, for: urlString)
                    svgImage = uiImage
                } catch {}
            }
        } else {
            RemoteImageView(url: imagePath)
        }
    }
}
