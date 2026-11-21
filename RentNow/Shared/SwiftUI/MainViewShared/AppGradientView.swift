//
//  AppGradientView.swift
//  Holool
//
//  Created by Elshamy on 03/11/2025.
//

import SwiftUI

struct SplashGradientView: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(.splashColor1),
                Color(.splashColor2)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

    }
}

struct TabbarGradientView: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(.splashColor1).opacity(0.35),
                Color(.splashColor1).opacity(0.75),
                Color(.splashColor1).opacity(0.75),
                Color(.splashColor1).opacity(0.35),
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .ignoresSafeArea()

    }
}
   
struct buttonGradientView: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(.splashColor1).opacity(0.35),
                Color(.splashColor1).opacity(0.35),
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .ignoresSafeArea()

    }
}


struct MainGradientView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "#7A9BB8"), // Steel blue (top-left)
                Color(hex: "#B8C5C9"), // Light gray-blue (middle)
                Color(hex: "#E5D9C3")  // Cream/beige (bottom-right)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}




extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
