//
//  GeneralNormalTextView.swift
//  Holool
//
//  Created by Elshamy on 09/11/2025.
//

import SwiftUI

// Custom alignment for input fields
extension VerticalAlignment {
    private struct InputFieldAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[VerticalAlignment.center]
        }
    }

    static let inputFieldAlignment = VerticalAlignment(InputFieldAlignment.self)
}

struct AppTextView: View {
    var title: String
    var secondaryTitle: String? = nil
    var secondaryTitleColor: Color = .gray
    var image: String
    var placeHolder: String
    var keyboardType: UIKeyboardType = .default
    var isRequired: Bool = false
    var suffix: String? = nil
    var isEditable: Bool = true
    @Binding var text: String
    @Binding var textError: String?


    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title with required indicator
            HStack(spacing: 4) {
                Text(title)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.black)

                if isRequired {
                    Text("*")
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(.red)
                }

                if let secondary = secondaryTitle {
                    Text(secondary)
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(secondaryTitleColor)
                }
            }

            VStack(spacing:0) {

                HStack(spacing: 8) {
                    if image != "" {

                        Image(image)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .scaledToFit()
                    }

                    FixedTextField(
                        placeholder: placeHolder,
                        keyboardType: keyboardType,
                        text: $text,
                        isEditable: isEditable
                    )

                    if let suffix = suffix {
                        Text(suffix)
                            .expoSystemFont(size: FontSize.normal, weight: .medium)
                            .foregroundColor(.mainColor)
                    }
                }
                .padding()
                .frame(height: 50)
                .alignmentGuide(.inputFieldAlignment) { d in d[VerticalAlignment.center] }
                .glassyBackground(cornerRadius: 12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(
                    (textError != nil) ? Color.red : Color.clear,
                    lineWidth: 0.7
                ))

                if textError != nil {
                    HStack {
                        Text(textError ?? "")
                           .expoSystemFont(size: FontSize.small, weight: .medium)
                            .foregroundColor(.red)
                            .padding(8)
                        Spacer()
                    }
                }

            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    AppTextView(title: "Name", image: "user", placeHolder: "Enter your name", text: .constant("please enter your name"), textError: .constant("vccv"))
}
