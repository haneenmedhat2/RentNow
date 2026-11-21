//
//  OrderDetailsPricingSummaryView.swift
//  RentNow
//

import SwiftUI

protocol PricingSummaryDisplayable {
    var pricePerDay: Double? { get }
    var numberOfDays: Int? { get }
    var featuresCost: Double? { get }
    var deliveryCost: Double? { get }
    var returnPickupCost: Double? { get }
    var insuranceValue: Double? { get }
    var discountAmount: Double? { get }
    var appFeesAmount: Double? { get }
    var totalBeforeVat: Double? { get }
    var vatPercentege: Double? { get }
    var vatValue: Double? { get }
    var total: Double? { get }
}

extension PaymentInfoData: PricingSummaryDisplayable {}
extension OrderPaymentSummary: PricingSummaryDisplayable {}

struct OrderDetailsPricingSummaryView: View {
    let data: any PricingSummaryDisplayable

    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 12) {
                moneyRow(title: "Price per day".localized, value: data.pricePerDay)
//                infoRow(title: "Number of rental days".localized, value: daysString(data.numberOfDays))
                moneyRow(title: "Features cost".localized, value: data.featuresCost)
                moneyRow(title: "pickup from lessor cost".localized, value: data.deliveryCost)
                moneyRow(title: "Return pickup price".localized, value: data.returnPickupCost)
                moneyRow(title: "Insurance amount".localized, value: data.insuranceValue)
                moneyRow(title: "Discount amount".localized, value: data.discountAmount)
                moneyRow(title: "Application fees amount".localized, value: data.appFeesAmount)
                moneyRow(title: "Total before VAT".localized, value: data.totalBeforeVat)
                infoRow(title: "VAT percentage".localized, value: percentString(data.vatPercentege))
                moneyRow(title: "VAT value".localized, value: data.vatValue)
//                moneyRow(title: "Final total".localized, value: data.total)
            }

            HStack(spacing: 6) {
                Text("Total".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.grayTextColor)
                Spacer()

                Text("\(data.total ?? 0) " + "SAR".localized)
                    .expoSystemFont(size: FontSize.large, weight: .medium)
                    .foregroundColor(.mainColor)
             
            }
        }
        .padding(16)
        .glassyBackground(cornerRadius: 16)
    }

    @ViewBuilder
    private func moneyRow(title: String, value: Double?) -> some View {
        if let value = value, value > 0 {
            HStack {
                Text(title)
                    .expoSystemFont(size: FontSize.normal, weight: .regular)
                    .foregroundColor(.grayTextColor)
                Spacer()
                Text("\(Int(value)) " + "SAR".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.black)
            }
        }
    }

    @ViewBuilder
    private func infoRow(title: String, value: String) -> some View {
        if !value.isEmpty {
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

    private func daysString(_ value: Int?) -> String {
        guard let value = value, value > 0 else { return "" }
        return "\(value)"
    }

    private func percentString(_ value: Double?) -> String {
        guard let value = value, value > 0 else { return "" }
        return "\(Int(value))%"
    }
}
