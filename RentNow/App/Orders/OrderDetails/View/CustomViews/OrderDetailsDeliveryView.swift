//
//  OrderDetailsDeliveryView.swift
//  RentNow
//

import SwiftUI

struct OrderDetailsDeliveryView: View {
    let data: DeliveryInfoData
    var hasValidLocation: Bool = false
    var onLocationTap: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 8)  {
            Text("Delivery Data".localized)
                .expoSystemFont(size: FontSize.large, weight: .bold)
                .foregroundColor(.black)

            VStack{

                VStack(spacing: 8) {
                    infoRow(title: "Delivery Method".localized, value: data.deliveryMethod ?? "")
                    locationRow(title: "Delivery Location".localized, value: data.deliveryLocation ?? "")
                    if !(data.notes ?? "").isEmpty {
                        infoRow(title: "Notes".localized, value: data.notes ?? "")
                    }
                }
            }
            .padding(16)
            .glassyBackground(cornerRadius: 16)
        }
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
                .multilineTextAlignment(.trailing)
        }
    }

    private func locationRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .expoSystemFont(size: FontSize.normal, weight: .regular)
                .foregroundColor(.text)
            Spacer()
            Text(value)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.black)
                .underline(hasValidLocation)
                .multilineTextAlignment(.trailing)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if hasValidLocation { onLocationTap() }
        }
    }
}


