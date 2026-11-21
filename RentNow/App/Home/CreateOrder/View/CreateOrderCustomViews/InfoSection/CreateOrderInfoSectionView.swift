//
//  CreateOrderInfoSectionView.swift
//  RentNow
//

import SwiftUI

struct CreateOrderInfoSectionView: View {
    let rentalPolicy: RentalPolicy?

    private var hasAnyData: Bool {
        guard let policy = rentalPolicy else { return false }
        return (policy.insuranceValue ?? 0) > 0 ||
               (policy.minKilometesUsage ?? 0) > 0 ||
               (policy.maxKilometesUsage ?? 0) > 0 ||
               (policy.extraKilometerPrice ?? 0) > 0
    }

    var body: some View {
        if hasAnyData {
            VStack(alignment: .leading, spacing: 12) {
                Text("Please fill in the following data".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.black)

                VStack(spacing: 12) {
                    if let insurance = rentalPolicy?.insuranceValue, insurance > 0 {
                        infoRow(
                            title: "Insurance amount".localized,
                            value: "\(Int(insurance))",
                            unit: "SAR".localized
                        )
                    }

                    if let minKm = rentalPolicy?.minKilometesUsage, minKm > 0 {
                        infoRow(
                            title: "Min Kilometers".localized,
                            value: "\(Int(minKm))",
                            unit: "km".localized
                        )
                    }

                    if let maxKm = rentalPolicy?.maxKilometesUsage, maxKm > 0 {
                        infoRow(
                            title: "Max Kilometers".localized,
                            value: "\(Int(maxKm))",
                            unit: "km".localized
                        )
                    }

                    if let extraKm = rentalPolicy?.extraKilometerPrice, extraKm > 0 {
                        infoRow(
                            title: "Extra Kilometer Price".localized,
                            value: "\(Int(extraKm))",
                            unit: "SAR".localized
                        )
                    }
                }
                .padding(12)
                .glassyBackground(cornerRadius: 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.secondBorder, lineWidth: 1)
                )
            }
            .padding(.horizontal, 16)
        }
    }

    private func infoRow(title: String, value: String, unit: String) -> some View {
        HStack {
          

            Text(title)
                .expoSystemFont(size: FontSize.normal, weight: .regular)
                .foregroundColor(.text)
            Spacer()
            Text(value + " " + unit)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.black)
           
        }
    }
}

