//
//  AirportRadioButtonView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct AirportRadioButtonView: View {
    // MARK: - Properties
    let airport: Airport
    let isSelected: Bool
    var onTap: () -> Void

    // MARK: - Body
    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "circle.inset.filled" : "circle")
                    .foregroundColor(isSelected ? .mainColor : .gray)
                    .font(.system(size: 24))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(airport.name)
                        .expoSystemFont(size: 14, weight: .medium)
                        .foregroundColor(.primary)

                    Text(airport.cityName)
                        .expoSystemFont(size: 12, weight: .regular)
                        .foregroundColor(.gray)
                }

                Spacer()

              
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                isSelected
                    ? Color.white.opacity(0.3)
                    : Color.clear
            )
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.mainColor.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 12) {
        AirportRadioButtonView(
            airport: Airport(
                id: 1,
                name: "مطار القاهرة الدولي",
                deliveryCost: 0,
                cityId: 1,
                cityName: "القاهرة"
            ),
            isSelected: true,
            onTap: {}
        )

        AirportRadioButtonView(
            airport: Airport(
                id: 2,
                name: "مطار برج العرب",
                deliveryCost: 50,
                cityId: 2,
                cityName: "الإسكندرية"
            ),
            isSelected: false,
            onTap: {}
        )
    }
    .padding()
}
