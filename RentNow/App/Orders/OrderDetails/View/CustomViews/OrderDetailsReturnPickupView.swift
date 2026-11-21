//
//  OrderDetailsReturnPickupView.swift
//  RentNow
//

import SwiftUI

struct OrderDetailsReturnPickupView: View {
    let data: ReturnPickupInfoData
    let hasValidLocation: Bool
    var onLocationTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8)  {
            Text("Return Data".localized)
                .expoSystemFont(size: FontSize.large, weight: .bold)
                .foregroundColor(.black)

            VStack{

                VStack(spacing: 8) {
                    infoRow(title: "Return Method".localized, value: data.returnPickupMethod ?? "")
                    locationRow(title: "Return Location".localized, value: data.returnPickupLocation ?? "")
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
