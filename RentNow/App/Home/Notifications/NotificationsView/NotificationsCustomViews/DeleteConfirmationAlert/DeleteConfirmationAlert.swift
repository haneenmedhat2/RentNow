//
//  DeleteConfirmationAlert.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct DeleteConfirmationAlert: ViewModifier {

    // MARK: - Properties
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let confirmButtonTitle: String
    let onConfirm: () -> Void
    let onCancel: () -> Void

    // MARK: - Body
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $isPresented) {
                Button("cancel".localized, role: .cancel) {
                    onCancel()
                }
                Button(confirmButtonTitle, role: .destructive) {
                    onConfirm()
                }
            } message: {
                Text(message)
            }
    }
}

// MARK: - View Extension
extension View {
    func deleteConfirmationAlert(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        confirmButtonTitle: String,
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) -> some View {
        self.modifier(
            DeleteConfirmationAlert(
                isPresented: isPresented,
                title: title,
                message: message,
                confirmButtonTitle: confirmButtonTitle,
                onConfirm: onConfirm,
                onCancel: onCancel
            )
        )
    }
}
