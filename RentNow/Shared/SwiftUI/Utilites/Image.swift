//
//  Image.swift

//

import Foundation
import Kingfisher
import SwiftUI

struct KFImageView: View {
    let stringURL: String?

    var body: some View {
        if let url = url {
            KFImage(url)
                .placeholder {
                    Image("LOGO")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .onFailure { _ in
                    Image("LOGO")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .fade(duration: 0.4)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else {
            Image("LOGO")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }

    private var url: URL? {
        guard let stringURL = stringURL else { return nil }
        return URL(string: stringURL)
    }
}


struct FillKFImageView: View {
    let stringURL: String?

    var body: some View {
        if let url = url {
            KFImage(url)
                .placeholder {
                    Image("LOGO")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .onFailure { _ in
                    Image("LOGO")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .fade(duration: 0.4)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            Image("LOGO")
                .resizable()
                .aspectRatio(contentMode: .fill)
        }
    }

    private var url: URL? {
        guard let stringURL = stringURL else { return nil }
        return URL(string: stringURL)
    }
}
