//
//  OrderDetailsRatingCardView.swift
//  RentNow
//

import SwiftUI

struct OrderDetailsRatingCardView: View {

    let rateData: RateData

    var body: some View {
        RatingCardView(
            image: rateData.image ?? "",
            name: rateData.name ?? "",
            date: rateData.date,
            rating: rateData.rate ?? 0
        )
    }
}

#Preview {
    OrderDetailsRatingCardView(rateData: RateData(rate: 4.5))
}

extension RateData {
    init(rate: Double? = 4.0, image: String? = nil, name: String? = "محمد الدوشان", date: String? = "24 مايو,2025") {
        self.rate = rate
        self.image = image
        self.name = name
        self.date = date
    }

}
