//
//  MyRatingItemCardView.swift
//  RentNow
//

import SwiftUI

struct MyRatingItemCardView: View {

    let item: MyRateItem

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Rating Section
            Text("Rating".localized)
                .expoSystemFont(size: FontSize.normal, weight: .semiBold)
                .foregroundColor(.black)

            RatingCardView(
                image: item.rateDetails?.raterImage ?? "",
                name: item.rateDetails?.raterName ?? "",
                date: item.rateDetails?.ratingDateFormatted,
                rating: item.rateDetails?.ratingCount ?? 0
            )

            // Car Data Section
            Text("Car Data".localized)
                .expoSystemFont(size: FontSize.normal, weight: .semiBold)
                .foregroundColor(.black)

            HStack(spacing: 12) {
                RemoteImageView(url: item.adDetails?.mainImage ?? "")
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                VStack(alignment: .leading, spacing: 6) {
                    Text(item.adDetails?.adName ?? "")
                        .expoSystemFont(size: FontSize.normal, weight: .semiBold)
                        .foregroundColor(.black)
                        .lineLimit(1)

                    HStack(spacing: 4) {
                        Image(systemName: "building.2")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(item.adDetails?.city ?? "")
                            .expoSystemFont(size: FontSize.normal, weight: .regular)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        Text(item.adDetails?.address ?? "")
                            .expoSystemFont(size: FontSize.normal, weight: .regular)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                }

                Spacer()
            }
            .padding(12)
            .glassyBackground(cornerRadius: 8)
        }
        .padding(16)
        .glassyBackground(cornerRadius: 12)
    }
}

#Preview {
    let json = """
    {"rateDetails":{"raterName":"محمد","ratingDate":"24 مايو,2025","ratingCount":4.5},"adDetails":{"adName":"كامري 2024","city":"الرياض","address":"حي النزهة","mainImage":""}}
    """.data(using: .utf8)!
    let item = try! JSONDecoder().decode(MyRateItem.self, from: json)
    MyRatingItemCardView(item: item)
}
