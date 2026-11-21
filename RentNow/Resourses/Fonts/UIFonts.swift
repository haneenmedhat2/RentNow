//
//  UIFonts.swift
//  App
//
//  Created by MGAbouarab on 29/12/2023.
//  Updated & fixed for ExpoArabic family
//

import UIKit
import ObjectiveC.runtime

// MARK: - Debug Helper
extension UIFont {
    static func printAllFonts() {
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            if family.contains("Plex") || family.contains("Inter") {
                print("Family: \(family) Font names: \(names)")
            }
        }
    }
}

// MARK: - UIFontDescriptor helper
extension UIFontDescriptor.AttributeName {
    static let nsctFontUIUsage = UIFontDescriptor.AttributeName(rawValue: "NSCTFontUIUsageAttribute")
}

// MARK: - Font Names & Mapping
public extension UIFont {

    enum FontNames {
        static var family: String {
            Language.currentLang() == .arabic ? "IBMPlexSansArabic" : "Inter"
        }

        case regular
        case light
        case medium
        case semiBold
        case bold
        case thin
        case extraLight
        case extraBold
        case black

        var name: String {
            Language.currentLang() == .arabic ? arabicName : englishName
        }

        private var arabicName: String {
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

        private var englishName: String {
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
}

// MARK: - Public App Fonts
public extension UIFont {

    private static func font(_ type: FontNames, size: CGFloat, fallback: UIFont.Weight) -> UIFont {
        let adjusted = size + 2
        return UIFont(name: type.name, size: adjusted)
            ?? .systemFont(ofSize: adjusted, weight: fallback)
    }

    static func appRegular(size: CGFloat) -> UIFont {
        font(.regular, size: size, fallback: .regular)
    }

    static func appLight(size: CGFloat) -> UIFont {
        font(.light, size: size, fallback: .light)
    }

    static func appMedium(size: CGFloat) -> UIFont {
        font(.medium, size: size, fallback: .medium)
    }

    static func appSemiBold(size: CGFloat) -> UIFont {
        font(.semiBold, size: size, fallback: .semibold)
    }

    static func appBold(size: CGFloat) -> UIFont {
        font(.bold, size: size, fallback: .bold)
    }

    // requested virtual types
    static func appThin(size: CGFloat) -> UIFont {
        font(.thin, size: size, fallback: .light)
    }

    static func appExtraLight(size: CGFloat) -> UIFont {
        font(.extraLight, size: size, fallback: .light)
    }

    static func appExtraBold(size: CGFloat) -> UIFont {
        font(.extraBold, size: size, fallback: .bold)
    }

    static func appBlack(size: CGFloat) -> UIFont {
        font(.black, size: size, fallback: .bold)
    }
}

// MARK: - ObjC / Storyboard Support
public extension UIFont {

    @objc class func myRegularFont(ofSize size: CGFloat) -> UIFont {
        appRegular(size: size)
    }

    @objc class func myMediumFont(ofSize size: CGFloat) -> UIFont {
        appMedium(size: size)
    }

    @objc class func myBoldFont(ofSize size: CGFloat) -> UIFont {
        appBold(size: size)
    }

    @objc convenience init?(myCoder aDecoder: NSCoder) {
        guard
            let fontDescriptor = aDecoder.decodeObject(forKey: "UIFontDescriptor") as? UIFontDescriptor,
            let fontAttribute = fontDescriptor.fontAttributes[.nsctFontUIUsage] as? String
        else {
            self.init(myCoder: aDecoder)
            return
        }

        let fontName: String

        switch fontAttribute {
        case "CTFontLightUsage":
            fontName = FontNames.light.name
        case "CTFontRegularUsage":
            fontName = FontNames.regular.name
        case "CTFontMediumUsage":
            fontName = FontNames.medium.name
        case "CTFontEmphasizedUsage", "CTFontBoldUsage":
            fontName = FontNames.bold.name
        case "CTFontHeavyUsage":
            fontName = FontNames.black.name
        default:
            fontName = FontNames.regular.name
        }

        self.init(name: fontName, size: fontDescriptor.pointSize)
    }
}

// MARK: - Global Font Override (Optional)
public extension UIFont {

    class func overrideInitialize() {
        guard self == UIFont.self else { return }

        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
           let mySystemFontMethod = class_getClassMethod(self, #selector(myRegularFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }

        if let boldSystemFontMethod = class_getClassMethod(self, #selector(boldSystemFont(ofSize:))),
           let myBoldSystemFontMethod = class_getClassMethod(self, #selector(myBoldFont(ofSize:))) {
            method_exchangeImplementations(boldSystemFontMethod, myBoldSystemFontMethod)
        }
    }
}
