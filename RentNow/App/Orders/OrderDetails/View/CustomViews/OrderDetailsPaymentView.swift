//
//  OrderDetailsPaymentView.swift
//  RentNow
//

import SwiftUI

struct OrderDetailsPaymentView: View {
    let data: PaymentInfoData

    var body: some View {
     

            VStack(spacing: 8) {
                infoRow(title: "Payment Method".localized, value: data.paymentMethod ?? "")
                infoRow(title: "Rent Price".localized, value: "\(data.rentPrice ?? 0) " + "SAR".localized)
                infoRow(title: "Delivery Price".localized, value: "\(data.deliveryPrice ?? 0) " + "SAR".localized)
                infoRow(title: "Tax".localized, value: "\(data.tax ?? 0) " + "SAR".localized)

                Divider()

                HStack {
                    Text("Total".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .bold)
                        .foregroundColor(.black)
                    Spacer()
                    Text("\(data.total ?? 0) " + "SAR".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .bold)
                        .foregroundColor(.mainColor)
                }
            }
        
        .padding(16)
        .glassyBackground(cornerRadius: 16)
    }

    private func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .expoSystemFont(size: FontSize.normal, weight: .regular)
                .foregroundColor(.grayTextColor)
            Spacer()
            Text(value)
                .expoSystemFont(size: FontSize.normal, weight: .medium)
                .foregroundColor(.black)
        }
    }
}

