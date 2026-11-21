//
//  AdvertisementDetailsSimilarAdsView.swift
//  RentNow
//

import SwiftUI

struct AdvertisementDetailsSimilarAdsView: View {

    let relatedAds: [Advertisement]
    let onCarTap: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle
            adsGrid
        }
        .padding(.top, 8)
    }

    // MARK: - Section Title

    private var sectionTitle: some View {
        Text("ad_details_similar_ads".localized)
            .expoSystemFont(size: FontSize.normal, weight: .bold)
            .foregroundColor(.black)
            .padding(.horizontal, 16)
    }

    // MARK: - Ads Grid

    private var adsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0)
        ], spacing: 4) {
            ForEach(relatedAds) { ad in
                MainCategoryDetailsCarCardView(advertisement: ad)
                    .padding(6)
                    .onTapGesture {
                        onCarTap(ad.id)
                    }
            }
            if relatedAds.count % 2 != 0 {
                Color.clear
            }
        }
        .padding(.horizontal, 16)
    }
}
