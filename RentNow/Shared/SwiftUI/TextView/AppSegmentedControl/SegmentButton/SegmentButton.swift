//
//  SegmentButton.swift
//  Holool
//
//  Created by Elshamy on 02/12/2025.
//

import SwiftUI

struct SegmentButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                RadioButton(isSelected: isSelected)
                
                Text(title)
                   .expoSystemFont(size:FontSize.normal , weight: .medium)
                    .foregroundColor(.black)
                    .lineLimit(1)

                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.secoundryMain : Color.white.opacity(0.6), lineWidth: 1.5)
            )
        }
        .glassyBackground(cornerRadius: 8)
    }
}


struct AppSegmentButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                RadioButton(isSelected: isSelected)

                Text(title)
                   .expoSystemFont(size:FontSize.normal , weight: .regular)
                    .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}
