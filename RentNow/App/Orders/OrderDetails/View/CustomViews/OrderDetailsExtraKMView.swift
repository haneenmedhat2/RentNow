//
//  OrderDetailsExtraKMView.swift
//  RentNow
//

import SwiftUI

struct OrderDetailsExtraKMView: View {
    let data: ExtraKilometersData
    var onPaymentTap: () -> Void
    var isProvider = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("You have more kilometers than allowed.".localized)
                .expoSystemFont(size: FontSize.large, weight: .bold)
                .foregroundColor(.black)



            VStack(spacing: 8) {
                infoRow(title: "Extra Kilometers".localized, value: "\(data.extraKilometers ?? 0) " + "km".localized)
                infoRow(title: "Price per Kilometer".localized, value: "\(data.pricePerKilometer ?? 0) " + "SAR".localized)


                  Divider()
                HStack {
                    Text("Total".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .bold)

                    Spacer()
                    Text("\(data.total ?? 0) " + "SAR".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .bold)
                        .foregroundColor(.mainColor)
                }


            }

            if data.canPayExceededKilometers == true , isProvider == false {
                MainButton(title: "Payment".localized) {
                    onPaymentTap()
                }
            }
        }
        .padding(16)
        .glassyBackground(cornerRadius: 16)
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .expoSystemFont(size: FontSize.normal, weight: .regular)
                .foregroundColor(.text)
            Spacer()
            Text(value)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.black)
        }
    }
}

