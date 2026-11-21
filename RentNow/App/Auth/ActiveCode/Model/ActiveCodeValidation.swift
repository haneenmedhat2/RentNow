//
//  ActiveCodeValidation.swift
//  Holool
//
//  Created by Elshamy on 21/12/2025.
//

import Foundation

// MARK: - Active Code Validation Logic
struct ActiveCodeValidation {

    // MARK: - Validation Methods

    static func validateCode(_ code: String?) -> String? {
        do {
            _ = try GeneralValidationService.validate(code: code)
            return nil
        } catch {
            return error.localizedDescription
        }
    }

    // MARK: - Validate Code Form

    static func validateCodeForm(code: String?) -> String? {
        return validateCode(code)
    }
}
