//
//  AppTextEditor.swift
//  Holool
//
//  Created by Elshamy on 02/12/2025.
//

import SwiftUI

struct AppTextEditor: View {
    var title: String
    var secondaryTitle: String? = nil
    var secondaryTitleColor: Color = .gray
    var image: String = ""
    var placeHolder: String
    var maxCharacters: Int?
    @Binding var text: String
    @Binding var textError: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let secondary = secondaryTitle {
                    HStack(spacing: 4) {
                        Text(title)
                            .expoSystemFont(size: FontSize.normal, weight: .medium)
                            .foregroundColor(.black)

                        Text(secondary)
                            .expoSystemFont(size: FontSize.normal, weight: .medium)
                            .foregroundColor(.text)
                    }
                } else {
                    Text(title)
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                }

                Spacer()

                if let max = maxCharacters {
                    Text("\(text.count)/\(max)")
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor(.gray)
                }
            }
            
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    if image != "" {
                        HStack {
                            Image(image)
                                .resizable()
                                .frame(width: 25, height: 25)
                                .scaledToFit()
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                    }
                    
                    ZStack(alignment: .topLeading) {
                        if text.isEmpty {
                            Text(placeHolder)
                               .expoSystemFont(size: FontSize.normal, weight: .regular)
                                .foregroundColor(Color(hex: "#777777"))
                                .padding(.top, 8)
                                .padding(.leading, 8)
                        }

                        TextEditor(text: $text)
                           .expoSystemFont(size: FontSize.normal, weight: .regular)
                            .frame(height: 80)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                            .onChange(of: text) { newValue in
                                if let max = maxCharacters, newValue.count > max {
                                    text = String(newValue.prefix(max))
                                }
                            }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.21))
                        .blur(radius: 50)
                )
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.21))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            (textError != nil) ? Color.red : Color.white.opacity(0.6),
                            lineWidth: 0.7
                        )
                )

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
