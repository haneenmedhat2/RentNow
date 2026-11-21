//
//  FilterSectionHeaderView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct FilterSectionHeaderView: View {

    let title: String

    var body: some View {
        Text(title)
            .expoSystemFont(size: FontSize.normal, weight: .bold)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    FilterSectionHeaderView(title: "Car Model")
        .padding()
}
