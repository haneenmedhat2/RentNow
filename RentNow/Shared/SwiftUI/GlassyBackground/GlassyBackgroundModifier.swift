//
//  ServiceCardView.swift
//  Holool
//
//  Created by Elshamy on 27/11/2025.
//

//
//  ServiceCardView.swift
//  Holool
//
//  Created by Elshamy on 26/11/2025.
//

import SwiftUI

struct GlassyBackgroundModifier: ViewModifier {
    var cornerRadius: CGFloat = 16
    
    func body(content: Content) -> some View {
        content
//            .background(
//                RoundedRectangle(cornerRadius: cornerRadius)
//                    .fill(Color.white.opacity(0.15))
//                    .background(
//                        RoundedRectangle(cornerRadius: cornerRadius)
//                            .stroke(Color.white.opacity(0.65), lineWidth: 0.8)
//                    )
//            )
//            .background(RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white.opacity(0.3)))
//            .overlay(
//                RoundedRectangle(cornerRadius: cornerRadius)
//                    .stroke(Color.white, lineWidth: 0.7)
//            )
//            .cornerRadius(cornerRadius)
//        
            .background(RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white.opacity(0.3)))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white, lineWidth: 0.7)
            )
    }
}

/// Adds a glassy translucent background with rounded corners.
/// Usage:
/// .glassyBackground(cornerRadius: 18)
extension View {
    func glassyBackground(cornerRadius: CGFloat = 16) -> some View {
        self.modifier(GlassyBackgroundModifier(cornerRadius: cornerRadius))
    }
}
