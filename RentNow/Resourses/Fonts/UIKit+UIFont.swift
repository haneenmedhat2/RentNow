//
//  UIKit+UIFont.swift
//  App
//
//  Created by MGAbouarab on 29/12/2023.
//  Fixed & aligned with ExpoArabic setup
//

import UIKit

// MARK: - Core Switch Helpers

private func mappedFontName(from currentFont: UIFont, to familyName: String) -> String {
    let current = currentFont.fontName.lowercased()

    // Mapping based on available fonts only
    if current.contains("black") || current.contains("extrabold") {
        return "\(familyName)-Bold"
    } else if current.contains("bold") {
        return "\(familyName)-Bold"
    } else if current.contains("semibold") {
        return "\(familyName)-SemiBold"
    } else if current.contains("medium") {
        return "\(familyName)-Medium"
    } else if current.contains("thin") || current.contains("extralight") || current.contains("light") {
        return "\(familyName)-Light"
    } else if current.contains("regular") {
        return "\(familyName)-Regular"
    } else {
        // safe default
        return "\(familyName)-Regular"
    }
}

private func switchFont(form font: UIFont?, to familyName: String) -> UIFont? {
    guard let font = font else { return nil }
    let newFontName = mappedFontName(from: font, to: familyName)
    return UIFont(name: newFontName, size: font.pointSize)
        ?? UIFont.systemFont(ofSize: font.pointSize)
}

private func switchFont(for attributedText: NSAttributedString?, to familyName: String) -> NSAttributedString? {
    guard let attributedText = attributedText, attributedText.length > 0 else { return nil }

    let range = NSRange(location: 0, length: attributedText.length)
    let mutable = NSMutableAttributedString(attributedString: attributedText)

    mutable.enumerateAttribute(.font, in: range) { value, subRange, _ in
        guard let font = value as? UIFont else { return }
        let newFontName = mappedFontName(from: font, to: familyName)
        let newFont = UIFont(name: newFontName, size: font.pointSize)
            ?? UIFont.systemFont(ofSize: font.pointSize)
        mutable.addAttribute(.font, value: newFont, range: subRange)
    }

    return mutable
}

////////////////////////////////////////////////////////////
// MARK: - UILabel
////////////////////////////////////////////////////////////

extension UILabel {

    @objc var substituteFontName: String {
        get { font.fontName }
        set {
            self.font = switchFont(form: self.font, to: newValue)
        }
    }

    @objc var substituteFontNameOfAttribute: String {
        get {
            guard let attributedText = attributedText, attributedText.length > 0 else { return "" }
            let attrs = attributedText.attributes(at: 0, effectiveRange: nil)
            return (attrs[.font] as? UIFont)?.fontName ?? ""
        }
        set {
            self.attributedText = switchFont(for: self.attributedText, to: newValue)
        }
    }
}

////////////////////////////////////////////////////////////
// MARK: - UITextView
////////////////////////////////////////////////////////////

extension UITextView {

    @objc var substituteFontName: String {
        get { font?.fontName ?? "" }
        set {
            self.font = switchFont(form: self.font, to: newValue)
        }
    }

    @objc var substituteFontNameOfAttribute: String {
        get {
            guard let attributedText = attributedText, attributedText.length > 0 else { return "" }
            let attrs = attributedText.attributes(at: 0, effectiveRange: nil)
            return (attrs[.font] as? UIFont)?.fontName ?? ""
        }
        set {
            self.attributedText = switchFont(for: self.attributedText, to: newValue)
        }
    }
}

////////////////////////////////////////////////////////////
// MARK: - UITextField
////////////////////////////////////////////////////////////

extension UITextField {

    @objc var substituteFontName: String {
        get { font?.fontName ?? "" }
        set {
            self.font = switchFont(form: self.font, to: newValue)
        }
    }

    @objc var substituteFontNameOfAttribute: String {
        get {
            guard let attributedText = attributedText, attributedText.length > 0 else { return "" }
            let attrs = attributedText.attributes(at: 0, effectiveRange: nil)
            return (attrs[.font] as? UIFont)?.fontName ?? ""
        }
        set {
            self.attributedText = switchFont(for: self.attributedText, to: newValue)
        }
    }
}

////////////////////////////////////////////////////////////
// MARK: - Global Override Entry Point
////////////////////////////////////////////////////////////

extension UIFont {

    static func overrideSystemFont() {
        let family = FontNames.family

        UILabel.appearance().substituteFontName = family
        UITextView.appearance().substituteFontName = family
        UITextField.appearance().substituteFontName = family

        UILabel.appearance().substituteFontNameOfAttribute = family
        UITextView.appearance().substituteFontNameOfAttribute = family
        UITextField.appearance().substituteFontNameOfAttribute = family
    }
}
