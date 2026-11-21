//
//  AdvertisementDetailsRatingsView.swift
//  RentNow
//

import SwiftUI

struct AdvertisementDetailsRatingsView: View {

    let rates: [AdvertisementRate]
    var onMoreTap: () -> Void

    var body: some View {
        if rates.isEmpty {
            // Leading title, centered "no ratings" text
            VStack(alignment: .leading, spacing: 12) {
                sectionTitle
                noRatingsText
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 8)
        } else {
            // Leading layout with horizontal scroll for ratings
            VStack(alignment: .leading, spacing: 12) {
                sectionTitle
                horizontalRatingsScroll
                moreButton
            }
            .padding(.top, 8)
        }
    }

    // MARK: - Section Title

    private var sectionTitle: some View {
        Text("ad_details_ratings".localized)
            .expoSystemFont(size: FontSize.normal, weight: .bold)
            .foregroundColor(.black)
            .padding(.horizontal, 16)
    }

    // MARK: - No Ratings

    private var noRatingsText: some View {
        Text("ad_details_no_ratings".localized)
            .expoSystemFont(size: FontSize.normal, weight: .regular)
            .foregroundColor(.black.opacity(0.6))
            .padding(.horizontal, 16)
    }

    // MARK: - Horizontal Ratings Scroll

    private var horizontalRatingsScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(rates) { rate in
                    RatingCardView(
                        image: rate.userImage ?? "",
                        name: rate.userName ?? "",
                        date: rate.createdAt,
                        rating: rate.rating ?? 0
                    )
                    .frame(width: 200)
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - More Button

    private var moreButton: some View {
        Button(action: onMoreTap) {
            Text("ad_details_more".localized)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.mainColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .glassyBackground(cornerRadius: 8)
        }
        .padding(.horizontal, 16)
    }
}

