//
//  FilterPriceRangeView.swift
//  RentNow
//

import SwiftUI

struct FilterPriceRangeView: View {

    @Binding var minValue: Double
    @Binding var maxValue: Double
    @Binding var isActive: Bool
    let minLimit: Double
    let maxLimit: Double

    private var minText: String {
        "\(Int(minValue)) " + "SAR".localized
    }

    private var maxText: String {
        if maxValue >= maxLimit {
            return "+\(Int(maxLimit)) " + "SAR".localized
        }
        return "\(Int(maxValue)) " + "SAR".localized
    }

    var body: some View {
        VStack(spacing: 16) {
            // Price display
            HStack {
                Text(minText)
                    .expoSystemFont(size: FontSize.small, weight: .medium)
                    .foregroundColor(.black)

                Text("-")
                    .foregroundColor(.black)

                Text(maxText)
                    .expoSystemFont(size: FontSize.small, weight: .medium)
                    .foregroundColor(.black)

                Text("/ day".localized)
                    .expoSystemFont(size: FontSize.small, weight: .regular)

                Spacer()
            }

            // Delegate to the reusable range slider
            RangeSliderView(
                lowerValue: $minValue,
                upperValue: $maxValue,
                range: minLimit...maxLimit
            )
            .onChange(of: minValue) { _ in isActive = true }
            .onChange(of: maxValue) { _ in isActive = true }
        }
        .padding(.vertical, 8)
    }
}

