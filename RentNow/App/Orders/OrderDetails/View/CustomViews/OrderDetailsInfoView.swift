//
//  OrderDetailsInfoView.swift
//  RentNow
//

import SwiftUI

struct OrderDetailsInfoView: View {
    let data: OrderInfoData

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Order Details".localized)
                .expoSystemFont(size: FontSize.large, weight: .bold)
                .foregroundColor(.black)
            VStack{


                VStack(spacing: 8) {
                    let dateValue = (data.rentalDateRangeFormatted?.isEmpty == false)
                        ? (data.rentalDateRangeFormatted ?? "")
                        : "\(data.startDate ?? "") - \(data.endDate ?? "")"
                    infoRow(title: "Rental date".localized, value: dateValue)

                    let timeValue = (data.bookingTimeFormatted?.isEmpty == false)
                        ? (data.bookingTimeFormatted ?? "")
                        : (data.bookingTime ?? "")
                    infoRow(title: "Booking time".localized, value: timeValue)

                    infoRow(title: "Number of Days".localized, value: "\(data.numberOfDays ?? 0) " + "days".localized)
                    infoRow(title: "Min Kilometers".localized, value: "\(data.minKilometers ?? 0) " + "km".localized)
                    infoRow(title: "Max Kilometers".localized, value: "\(data.maxKilometers ?? 0) " + "km".localized)
                    infoRow(title: "Extra Kilometer Price".localized, value: "\(data.extraKilometerPrice ?? 0) " + "SAR".localized)
                    infoRow(title: "Insurance Price".localized, value: "\(data.insurancePrice ?? 0) " + "SAR".localized)
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
        }
    }
}

