//
//  MainCategoryDetailsCarCardView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct MainCategoryDetailsCarCardView: View {

    let advertisement: Advertisement

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            GeometryReader { geo in
                RemoteImageView(url: advertisement.mainImageUrl)
                    .scaledToFill()
                    .frame(width: geo.size.width, height: 140)
                    .clipped()
            }
            .frame(minHeight: 140, maxHeight: 140)
            .padding(.top, 8)
            .padding(.horizontal, 8)

            VStack(alignment: .leading, spacing: 6) {
                // Rating
                if let rating = advertisement.averageRating {
                    
                        HStack(spacing: 4) {
                            
                            Image("star")
                                .scaledToFill()
                                .frame(width: 15 , height: 15)
                            
                            Text(String(format: "%.1f", rating))
                                .expoSystemFont(size: FontSize.normal, weight: .bold)
                                .foregroundColor(.text)
                     
                        }
                       

                    
                }

                // Name
                Text(advertisement.carName)
                    .expoSystemFont(size: FontSize.large, weight: .semiBold)
                    .lineLimit(1)
                
                // City
                HStack(spacing: 4) {
                    Image("city-01")
                        .scaledToFill()
                        .frame(width: 15 , height: 15)
                        
                    Text(advertisement.cityName)
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor(.text)

                        .lineLimit(1)
                }

                // Address
                HStack(spacing: 4) {
                    Image("pin-location-01")
                        .scaledToFill()
                        .frame(width: 15 , height: 15)
                    Text(advertisement.geoAddress)
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor(.text)
                        .lineLimit(1)
                }

                HStack(spacing: 4) {
                    Text("\(Int(advertisement.pricePerDay)) " + "SAR".localized)
                        .expoSystemFont(size: FontSize.large, weight: .bold)
                        .foregroundColor(.mainColor)
                    Text("/ " + "per_day".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .glassyBackground(cornerRadius: 0)
        
    }
}

#Preview {
    MainCategoryDetailsCarCardView(
        advertisement: Advertisement(
            id: 1,
            carName: "Toyota Camry 2023",
            averageRating: 4.5,
            cityName: "Riyadh",
            geoAddress: "King Fahd Road",
            pricePerDay: 150.0,
            mainImageUrl: "https://example.com/image.jpg"
        )
    )
    .frame(width: 180)
    .padding()
}
