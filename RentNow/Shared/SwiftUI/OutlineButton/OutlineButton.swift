//
//  OutlineButton.swift
//  Holool
//
//  Created by Elshamy on 30/12/2025.
//

import SwiftUI

struct OutlineButton: View {

    let title: String
    let action: () -> Void
    let image: String?
    let isDisabled: Bool

    // MARK: - Initializer
    init(
        title: String,
        action: @escaping () -> Void,
        image: String? = nil,
        isDisabled: Bool = false
    ) {
        self.title = title
        self.action = action
        self.image = image
        self.isDisabled = isDisabled
    }

    // MARK: - Computed Properties
    private var textColor: Color {
        isDisabled ? .gray : Color(red: 180/255, green: 100/255, blue: 80/255)
    }

    private var buttonOpacity: Double {
        isDisabled ? 0.6 : 1.0
    }

    // MARK: - Body
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center,spacing: 8) {
                if let image = image {
                    
                    Image(image)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(textColor)
                }

                Text(title)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(textColor)

               
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(textColor, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled)
        .opacity(buttonOpacity)
    }
}

