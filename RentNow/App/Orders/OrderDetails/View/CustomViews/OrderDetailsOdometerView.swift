//
//  OrderDetailsOdometerView.swift
//  RentNow
//

import SwiftUI

struct OrderDetailsOdometerView: View {
    let title: String
    let data: OdometerData
    var onImageTap: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .expoSystemFont(size: FontSize.large, weight: .bold)
                .foregroundColor(.black)

            HStack(spacing: 12) {
                Button {
                    onImageTap?()
                } label: {
                    RemoteImageView(url: data.odometerPhoto)
                        .frame(width: 100, height: 80)
                        .cornerRadius(8)
                }

                Text("\(Int(data.odometerReading ?? 0)) " + "km".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .bold)
                    .foregroundColor(.mainColor)

                Spacer()
            }
        }
        .padding(16)
        .glassyBackground(cornerRadius: 16)
    }
}

