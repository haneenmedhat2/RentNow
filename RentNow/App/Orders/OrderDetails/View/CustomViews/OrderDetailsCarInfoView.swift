//
//  OrderDetailsCarInfoView.swift
//  RentNow
//

import SwiftUI

struct OrderDetailsCarInfoView: View {
    let data: AdvertisementInfoData

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Car Data".localized)
                .expoSystemFont(size: FontSize.large, weight: .bold)
                .foregroundColor(.black)

            VStack {
                HStack(alignment: .top ,spacing: 12) {
                    RemoteImageView(url: data.images?.first)
                        .frame(width: 80, height: 60)
                        .cornerRadius(8)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(data.name ?? "")
                            .expoSystemFont(size: FontSize.normal, weight: .bold)
                            .foregroundColor(.black)

                        HStack(spacing: 4) {
                            Image("city-01")
                                .scaledToFill()
                                .frame(width: 15 , height: 15)


                            Text(data.city ?? "")
                                .expoSystemFont(size: FontSize.normal, weight: .regular)
                                .foregroundColor(.grayTextColor)
                                .lineLimit(1)
                        }

                        HStack(spacing: 4) {
                            Image("pin-location-01")
                                .scaledToFill()
                                .frame(width: 15 , height: 15)
                            Text(data.address ?? "")
                                .expoSystemFont(size: FontSize.normal, weight: .regular)
                                .foregroundColor(.text)
                                .lineLimit(1)
                        }

                        HStack(spacing: 4) {
                            Image("fuel-02")
                                .scaledToFill()
                                .frame(width: 15 , height: 15)
                            Text(data.fuelType ?? "")
                                .expoSystemFont(size: FontSize.normal, weight: .regular)
                                .foregroundColor(.grayTextColor)
                        }
                    }

                    Spacer()
                }
            }
            .padding(16)
            .glassyBackground(cornerRadius: 16)
        }
    }
}


