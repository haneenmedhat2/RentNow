//
//  OTPTextField.swift
//  Holool
//
//  Created by Elshamy on 11/11/2025.
//


import SwiftUI
import UIKit

struct OTPTextField: UIViewRepresentable {
    @Binding var text: String
    var isFocused: Bool
    var onDeleteBackward: () -> Void
    
    func makeUIView(context: Context) -> BackspaceAwareTextField {
        let textField = BackspaceAwareTextField()
        textField.textAlignment = .center
        textField.contentVerticalAlignment = .center
        textField.font = UIFont.boldSystemFont(ofSize: 22)
        textField.keyboardType = .asciiCapableNumberPad
        textField.delegate = context.coordinator
        textField.tintColor = .main
        textField.onDeleteBackward = onDeleteBackward
        textField.layer.masksToBounds = true
        textField.adjustsFontSizeToFitWidth = false
        textField.minimumFontSize = 22
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setContentHuggingPriority(.required, for: .horizontal)
        textField.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        // Force LTR (English) text direction
        textField.semanticContentAttribute = .forceLeftToRight
        textField.textAlignment = .center
        
        return textField
    }

    
    func updateUIView(_ uiView: BackspaceAwareTextField, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        
        if isFocused && !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        } else if !isFocused && uiView.isFirstResponder {
            uiView.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: OTPTextField
        
        init(_ parent: OTPTextField) {
            self.parent = parent
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if string.isEmpty {
                parent.text = ""
                return true
            }
            else if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil {
                parent.text = string
                return false
            }
            return false
        }
    }
}

final class BackspaceAwareTextField: UITextField {
    var onDeleteBackward: (() -> Void)?
    
    override func deleteBackward() {
        onDeleteBackward?()
        super.deleteBackward()
    }
}
