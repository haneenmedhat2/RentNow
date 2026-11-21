//
//  RadioButton.swift
//  Holool
//
//  Created by Elshamy on 09/12/2025.
//

import SwiftUI

struct RadioButton: View {
    let isSelected: Bool

    var body: some View {
        ZStack {
            Circle()
                .stroke(isSelected ? Color.mainColor : Color.secondaryDarkFont, lineWidth: 1)
                .frame(width: 20, height: 20)

            if isSelected {
                Circle()
                    .fill(Color.mainColor)
                    .frame(width: 12, height: 12)
            }
        }
        .frame(width: 20, height: 20)
    }
}
