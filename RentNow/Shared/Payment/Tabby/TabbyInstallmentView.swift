import SwiftUI
import Tabby

struct TabbyInstallmentView: View {
    enum Style {
        case promotional
        case checkout
    }

    let amount: Double
    let currency: String
    var isEmbedded = false
    var style: Style = .promotional

    var body: some View {
        if amount.isFinite, amount > 0, currency.isEmpty || currency.uppercased() == "SAR" {
            VStack(spacing: 12) {
                Group {
                    if style == .checkout {
                        TabbyCardView(
                            amount: amount,
                            currency: .SAR,
                            lang: TabbyConfiguration.language,
                            shouldInheritBg: true,
                            merchantCode: TabbyConfiguration.merchantCode
                        )
                    } else {
                        TabbyPromoView(amount: amount)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(isEmbedded ? 0 : 12)
                .background {
                    if !isEmbedded { Color.clear.glassyBackground(cornerRadius: 16) }
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))

                if style == .checkout {
                    // The SDK's native four-payment schedule matches the requested circular timeline.
                    TabbyCheckoutSnippet(
                        amount: amount,
                        currency: .SAR,
                        preferCurrencyInArabic: Language.isRTL()
                    )
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
            .environment(\.locale, Locale(identifier: Language.apiLanguage()))
            .environment(\.layoutDirection, Language.isRTL() ? .rightToLeft : .leftToRight)
            .id("\(amount)-\(currency)-\(Language.apiLanguage())")
        }
    }
}
