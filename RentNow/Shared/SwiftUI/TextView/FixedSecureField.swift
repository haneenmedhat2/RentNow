//
//  FixedSecureField.swift
//  Holool
//
//  Created by Elshamy on 24/12/2025.
//

import SwiftUI
import UIKit

/// SecureField that fixes Arabic RTL keyboard bug
struct FixedSecureField: UIViewRepresentable {
    let placeholder: String
    @Binding var text: String

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()

        textField.placeholder = placeholder
        textField.isSecureTextEntry = true
        textField.font = UIFont(name: "ExpoArabic-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        textField.tintColor = .main
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.delegate = context.coordinator
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textChanged), for: .editingChanged)

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        context.coordinator.parent = self
        uiView.text = text
        uiView.placeholder = placeholder
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: FixedSecureField

        init(_ parent: FixedSecureField) {
            self.parent = parent
        }

        @objc func textChanged(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}
