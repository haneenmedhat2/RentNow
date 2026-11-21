//
//  ExpoArabicFont.swift
//  Holool
//
//  Created by Elshamy on 15/12/2025.
//


//
//  ExpoArabicFont.swift
//  App
//
//  SwiftUI Font System for ExpoArabic
//

import SwiftUI

// MARK: - Global Font Sizes
struct FontSize {
    static let altraSmall: CGFloat = 10
    static let small: CGFloat = 12
    static let normal: CGFloat = 14
    static let large: CGFloat = 16
}

// MARK: - Font Types
enum ExpoArabicFont {

    case regular
    case light
    case medium
    case semiBold
    case bold
    case thin
    case extraLight
    case extraBold
    case black

    // MARK: - Font Name Mapping
    var fontName: String {
        Language.currentLang() == .arabic ? arabicFontName : englishFontName
    }

    private var arabicFontName: String {
        switch self {
        case .thin:       return "IBMPlexSansArabic-Thin"
        case .extraLight: return "IBMPlexSansArabic-ExtraLight"
        case .light:      return "IBMPlexSansArabic-Light"
        case .regular:    return "IBMPlexSansArabic-Regular"
        case .medium:     return "IBMPlexSansArabic-Medium"
        case .semiBold:   return "IBMPlexSansArabic-SemiBold"
        case .bold, .extraBold, .black:
            return "IBMPlexSansArabic-Bold"
        }
    }

    private var englishFontName: String {
        switch self {
        case .thin:       return "Inter-Thin"
        case .extraLight: return "Inter-ExtraLight"
        case .light:      return "Inter-Light"
        case .regular:    return "Inter-Regular"
        case .medium:     return "Inter-Medium"
        case .semiBold:   return "Inter-SemiBold"
        case .bold:       return "Inter-Bold"
        case .extraBold:  return "Inter-ExtraBold"
        case .black:      return "Inter-Black"
        }
    }
}

// MARK: - SwiftUI Font Extension
extension Font {

    /// Main entry point
    static func expo(
        _ type: ExpoArabicFont,
        size: CGFloat
    ) -> Font {
        .custom(type.fontName, size: size + 2)
    }

    // MARK: - Ready-made styles (اختياري بس عملي)
    static let expoH1      = Font.expo(.black, size: 24)
    static let expoH2      = Font.expo(.extraBold, size: 20)
    static let expoTitle   = Font.expo(.semiBold, size: 18)
    static let expoBody    = Font.expo(.regular, size: 16)
    static let expoCaption = Font.expo(.light, size: 12)
}

import SwiftUI

// MARK: - System Font Modifier
struct ExpoArabicSystemFont: ViewModifier {

    var size: CGFloat
    var weight: ExpoArabicFont

    func body(content: Content) -> some View {
        content
            .font(.expo(weight, size: size))
    }
}

extension View {

    /// Use ExpoArabic as system-like font
    func expoSystemFont(
        size: CGFloat = FontSize.normal,
        weight: ExpoArabicFont = .regular
    ) -> some View {
        self.modifier(
            ExpoArabicSystemFont(
                size: size,
                weight: weight
            )
        )
    }
}

