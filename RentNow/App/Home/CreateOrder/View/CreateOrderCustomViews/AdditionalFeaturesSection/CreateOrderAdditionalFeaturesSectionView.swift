//
//  CreateOrderAdditionalFeaturesSectionView.swift
//  RentNow
//

import SwiftUI

struct CreateOrderAdditionalFeaturesSectionView: View {
    let features: [OrderAdditionalFeature]
    let selectedFeatureIds: Set<Int>
    var onToggleFeature: (Int?) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Additional features".localized)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.black)

            ForEach(features, id: \.id) { feature in
                Button {
                    onToggleFeature(feature.id)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: selectedFeatureIds.contains(feature.id ?? 0) ? "checkmark.square.fill" : "square")
                            .foregroundColor(selectedFeatureIds.contains(feature.id ?? 0) ? .mainColor : .gray)
                            .font(.system(size: 22))

                        Text(feature.name ?? "")
                            .expoSystemFont(size: FontSize.normal, weight: .regular)
                            .foregroundColor(.black)

                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
