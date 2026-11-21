//
//  LinearGradient+Extensions.swift
//  Holool
//
//  Created by Elshamy on 08/12/2025.
//

import SwiftUI

extension LinearGradient {
    /// Main app gradient used for buttons and backgrounds
    /// Colors: D2592D -> 8F300E (trailing to leading)
    static var mainGradient: LinearGradient {
        let color1: Color = Color(hex: "#D2592D")
        let color2: Color = Color(hex: "#8F300E")
        return LinearGradient(
            colors: [color1, color2],
            startPoint: .trailing,
            endPoint: .leading
        )
    }

    /// Main app gradient (vertical variant)
    /// Colors: D2592D -> 8F300E (top to bottom)
    static var mainGradientVertical: LinearGradient {
        let color1: Color = Color(hex: "#D2592D")
        let color2: Color = Color(hex: "#8F300E")
        return LinearGradient(
            colors: [color1, color2],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - View Modifier
struct MainGradientModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(LinearGradient.mainGradient)
    }
}

extension View {
    /// Applies the main app gradient as background
    func mainGradientBackground() -> some View {
        modifier(MainGradientModifier())
    }
}
