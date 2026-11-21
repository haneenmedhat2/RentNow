//
//  CreateOrderCarInfoCardView.swift
//  RentNow
//

import SwiftUI

struct CreateOrderCarInfoCardView: View {
    let imageUrl: String
    let carName: String
    let cityName: String
    let address: String

    var body: some View {
        HStack(spacing: 12) {
            RemoteImageView(url: imageUrl)
                .scaledToFill()
                .frame(width: 80, height: 80)
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 4) {
                Text(carName)
                    .expoSystemFont(size: FontSize.large, weight: .bold)
                    .foregroundColor(.black)
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    Text(cityName)
                        .expoSystemFont(size: FontSize.small, weight: .regular)
                        .foregroundColor(.gray)
                }

                Text(address)
                    .expoSystemFont(size: FontSize.small, weight: .regular)
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(12)
        .glassyBackground(cornerRadius: 12)
        .padding(.horizontal, 16)
    }
}

#Preview {
    CreateOrderCarInfoCardView(
        imageUrl: "",
        carName: "Toyota Camry 2024",
        cityName: "Riyadh",
        address: "King Fahd Road"
    )
    .background(LinearGradient.mainGradient.ignoresSafeArea())
}
