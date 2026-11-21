//
//  FilterCheckboxRowView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct FilterCheckboxRowView: View {

    let title: String
    let isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? .mainColor : .gray)

                Text(title)
                    .expoSystemFont(size: FontSize.small, weight: .regular)
                    .foregroundColor(.black)

                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    VStack {
        FilterCheckboxRowView(title: "Petrol", isSelected: true, onTap: {})
        FilterCheckboxRowView(title: "Diesel", isSelected: false, onTap: {})
    }
    .padding()
}
