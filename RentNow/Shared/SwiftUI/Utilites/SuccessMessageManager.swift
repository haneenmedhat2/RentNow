//
//  SuccessMessageManager.swift
//  Nebealk
//
//  Created by Mohamed Elmemy on 10/08/2024.
//

import SwiftUI
import Combine

class SuccessMessageManager: ObservableObject {
    static let shared = SuccessMessageManager()

    @Published var successMessage: String? {
        didSet {
            if successMessage != nil {
                showMessage = true
            }
        }
    }

    @Published var showMessage: Bool = false
}

