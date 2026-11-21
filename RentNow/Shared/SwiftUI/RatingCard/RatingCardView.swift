//
//  RatingCardView.swift
//  RentNow
//

import SwiftUI

struct RatingCardView: View {

    let image: String
    let name: String
    let date: String?
    let rating: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                RemoteImageView(url: image)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 8) {
                    stars

                    HStack(spacing: 10) {
                        Text(name)
                            .expoSystemFont(size: FontSize.normal, weight: .semiBold)
                            .foregroundColor(.black)
                            .lineLimit(1)
                        if let date = date {
                            Text(date)
                                .expoSystemFont(size: 11, weight: .regular)
                                .foregroundColor(.black.opacity(0.6))
                        }
                    }
                }

                Spacer()
            }
        }
        .padding(12)
        .glassyBackground(cornerRadius: 8)
    }

    private var stars: some View {
        let fullStars = Int(rating)
        let hasHalf = (rating - Double(fullStars)) >= 0.5
        return HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                let imageName = index <= fullStars ? "star.fill" : (index == fullStars + 1 && hasHalf ? "star.leadinghalf.filled" : "star")
                let color: Color = index <= fullStars || (index == fullStars + 1 && hasHalf) ? .yellow : .black.opacity(0.4)
                Image(systemName: imageName)
                    .font(.system(size: 14))
                    .foregroundColor(color)
            }
        }
    }
}

#Preview {
    RatingCardView(image: "", name: "محمد الدوشان", date: "24 مايو,2025", rating: 4.5)
}
