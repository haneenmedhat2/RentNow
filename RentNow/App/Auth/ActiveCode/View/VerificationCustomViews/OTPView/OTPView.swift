//
//  OTPView.swift
//  Holool
//
//  Created by Elshamy on 11/11/2025.
//


import SwiftUI

struct OTPView: View {
    @Binding var code: String
    @Binding var showValidationError: Bool
    
    @State private var digits: [String] = Array(repeating: "", count: 4)
    @FocusState private var focusedIndex: Int?
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                ForEach(0..<4, id: \.self) { index in
                    OTPTextField(
                        text: $digits[index],
                        isFocused: focusedIndex == index,
                        onDeleteBackward: {
                            handleDelete(at: index)
                        }
                    )
                    .frame(width: 60, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(backgroundColor(for: index))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(borderColor(for: index), lineWidth: focusedIndex == index ? 2 : 1.5)
                    )
                    .scaleEffect(focusedIndex == index ? 1.05 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: focusedIndex == index)
                    .focused($focusedIndex, equals: index)
                    .onChange(of: digits[index]) { newValue in
                        handleInputChange(at: index, newValue: newValue)
                    }
                }
            }
            
            if showValidationError {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.circle.fill")
                       
               

                    Text("Please enter full code".localized)
                        .expoSystemFont(size: FontSize.small, weight: .medium)

                }
                .foregroundColor(.red)
                .transition(.opacity.combined(with: .scale(scale: 0.9)))
            }
        }
        .onAppear { focusedIndex = 0 }
        .onChange(of: digits) { _ in
            code = digits.joined()
            if digits.allSatisfy({ !$0.isEmpty }) {
                showValidationError = false
            }
        }
        .environment(\.layoutDirection, .leftToRight)
    }
    
    // MARK: - Input Logic
    private func handleInputChange(at index: Int, newValue: String) {
        if newValue.count > 1 {
            digits[index] = String(newValue.last!)
        }
        
        if newValue.count == 1 && index < 3 {
            focusedIndex = index + 1
        } else if newValue.count == 1 && index == 3 {
            focusedIndex = nil
        }
    }
    
    // MARK: - Delete Logic
    private func handleDelete(at index: Int) {
        Task { @MainActor in
            if digits[index].isEmpty && index > 0 {
                focusedIndex = index - 1
                digits[index - 1] = ""
            } else {
                digits[index] = ""
            }
        }
    }
    
    // MARK: - Styling
    private func backgroundColor(for index: Int) -> Color {
        if showValidationError && digits[index].isEmpty {
            return Color.red.opacity(0.1)
        }
        if focusedIndex == index {
            return Color.white.opacity(0.4)
        }
        return Color.white.opacity(0.25)
    }
    
    private func borderColor(for index: Int) -> Color {
        if showValidationError && digits[index].isEmpty {
            return .red
        }
        if focusedIndex == index {
            return .main
        }
        if !digits[index].isEmpty {
            return .main.opacity(0.8)
        }
        return .white.opacity(0.4)
    }
}
