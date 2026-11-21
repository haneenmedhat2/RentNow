//
//  AdvertisementDetailsBottomBarView.swift
//  RentNow
//

import SwiftUI

struct AdvertisementDetailsBottomBarView: View {

    let pricePerDay: Double
    let canBook: Bool
    let onBookTap: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.white.opacity(0.3))

            HStack(spacing: 0) {
                
                bookButton
                priceView
               
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
        .glassyBackground(cornerRadius: 0)
    }

    // MARK: - Price

    private var priceView: some View {
        HStack(spacing: 0) {
            Text("\(Int(pricePerDay)) " + "SAR".localized)
                .expoSystemFont(size: FontSize.large, weight: .bold)
                .foregroundColor(.main)
            
            Text( " / " + "day".localized)
                .expoSystemFont(size: FontSize.large, weight: .bold)
                .foregroundColor(.black)
        }
        
      
    }

    // MARK: - Book Button

    private var bookButton: some View {
        MainButton(title: "ad_details_book_car".localized) {
            onBookTap()
        }
        .opacity(canBook ? 1.0 : 0.5)
        .disabled(!canBook)
    }
}
