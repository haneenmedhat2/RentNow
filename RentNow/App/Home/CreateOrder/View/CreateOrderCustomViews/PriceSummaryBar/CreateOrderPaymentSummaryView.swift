import SwiftUI

struct CreateOrderPaymentSummaryView: View {
    let paymentSummary: OrderPaymentSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            moneyRow(title: rentalTitle(paymentSummary), value: paymentSummary.rentalCost)
            moneyRow(title: "Insurance amount".localized, value: paymentSummary.insuranceValue)
            moneyRow(title: "Features cost".localized, value: paymentSummary.featuresCost)
            moneyRow(title: "pickup from lessor cost".localized, value: paymentSummary.deliveryCost)
            moneyRow(title: "Return pickup price".localized, value: paymentSummary.returnPickupCost)
            moneyRow(title: "Application fees amount".localized, value: paymentSummary.appFeesAmount)
            moneyRow(title: "Discount amount".localized, value: paymentSummary.discountAmount, isDiscount: true)
            moneyRow(title: "VAT value".localized, value: paymentSummary.vatValue)

            Divider().padding(.vertical, 2)

            HStack(alignment: .firstTextBaseline) {
                Text("Total".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.grayTextColor)
                Spacer(minLength: 12)
                Text("\(amount(paymentSummary.total ?? 0)) \(currency.localized)")
                    .monospacedDigit()
                    .multilineTextAlignment(.trailing)
                    .expoSystemFont(size: FontSize.large, weight: .medium)
                    .foregroundColor(.mainColor)
            }
        }
        .expoSystemFont(size: FontSize.normal)
        .foregroundStyle(Color.grayTextColor)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .glassyBackground(cornerRadius: 12)
        .padding(.horizontal, 16)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("checkout_payment_details".localized)
    }

    private var currency: String {
        guard let currency = paymentSummary.currency, !currency.isEmpty else { return "SAR" }
        return currency
    }

    private func rentalTitle(_ summary: OrderPaymentSummary) -> String {
        guard let days = summary.numberOfDays, days > 0, let dailyPrice = summary.pricePerDay else {
            return "checkout_rental".localized
        }
        return "\("checkout_rental".localized) (\(amount(dailyPrice)) × \(days))"
    }

    @ViewBuilder
    private func moneyRow(title: String, value: Double?, isDiscount: Bool = false) -> some View {
        if let value, value != 0 {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Text(title)
                    .foregroundColor(.grayTextColor)
                Spacer(minLength: 8)
                Text("\(amount(isDiscount ? -abs(value) : value)) \(currency.localized)")
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.black)
                    .monospacedDigit()
                    .fixedSize(horizontal: true, vertical: false)
            }
        }
    }

    private func amount(_ value: Double) -> String {
        value.formatted(.number.locale(Locale(identifier: Language.currentLanguage())).precision(.fractionLength(2)))
    }
}
