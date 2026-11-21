//
//  MyAdDetailsAdditionalServicesView.swift
//  RentNow
//

import SwiftUI

struct MyAdDetailsAdditionalServicesView: View {

    let features: [AdditionalFeatureItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Additional Car Services".localized)
                .expoSystemFont(size: FontSize.normal, weight: .bold)
                .foregroundColor(.black)

            ForEach(features, id: \.id) { feature in
                HStack {
                    Text(feature.name ?? "")
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor(.black.opacity(0.9))
                    Spacer()
                    Text("\(Int(feature.featureCost ?? 0)) " + "SAR".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .semiBold)
                        .foregroundColor(.black.opacity(0.9))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .glassyBackground(cornerRadius: 8)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

