//
//  FixedTextField.swift
//  Holool
//
//  Created by Elshamy on 24/12/2025.
//

import SwiftUI
import UIKit

/// TextField that fixes Arabic RTL number keyboard bug
struct FixedTextField: UIViewRepresentable {
    let placeholder: String
    let keyboardType: UIKeyboardType
    @Binding var text: String
    var isEditable: Bool = true

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()

        // Fix RTL number keyboard issue
        if isNumberKeyboard(keyboardType) {
            textField.semanticContentAttribute = Language.isRTL() ? .forceRightToLeft : .forceLeftToRight
            textField.textAlignment = Language.isRTL() ? .right : .left
        }

        textField.placeholder = placeholder
        textField.keyboardType = englishNumberKeyboard(for: keyboardType)
        textField.font = UIFont(name: "ExpoArabic-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        textField.tintColor = .main
        textField.autocorrectionType = .no
        textField.delegate = context.coordinator
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textChanged), for: .editingChanged)
        textField.isUserInteractionEnabled = isEditable

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        context.coordinator.parent = self
        uiView.text = text
        uiView.placeholder = placeholder
        uiView.isUserInteractionEnabled = isEditable
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private func isNumberKeyboard(_ type: UIKeyboardType) -> Bool {
        switch type {
        case .numberPad, .phonePad, .decimalPad, .asciiCapableNumberPad:
            return true
        default:
            return false
        }
    }

    /// Force English (ASCII) digits for number-only keyboards.
    /// `.phonePad` and non-numeric keyboards are left unchanged.
    private func englishNumberKeyboard(for type: UIKeyboardType) -> UIKeyboardType {
        switch type {
        case .numberPad, .decimalPad:
            return .asciiCapableNumberPad
        default:
            return type
        }
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: FixedTextField

        init(_ parent: FixedTextField) {
            self.parent = parent
        }

        @objc func textChanged(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}
