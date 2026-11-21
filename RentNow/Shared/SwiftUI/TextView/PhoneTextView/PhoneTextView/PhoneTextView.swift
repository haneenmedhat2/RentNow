//
//  PhoneTextView.swift
//  RentNow
//
//  Created by Elshamy on 03/11/2025.
//

import SwiftUI

struct PhoneTextView: View {
    @Binding var phone: String
    @Binding var phoneError: String?
    @Binding var hasEditedPhone: Bool

    @Binding var countryCode: Country?
    var countries: [Country]

    var showErrorAlways: Bool = false
    var countryCodeError: String? = nil
    var isRequired: Bool = false

    private var shouldShowError: Bool {
        if showErrorAlways {
            return displayError != nil
        } else {
            return hasEditedPhone && phoneError != nil
        }
    }

    private var displayError: String? {
        phoneError ?? countryCodeError
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Label with required indicator
            HStack(spacing: 4) {
                Text("Phone".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.black)

                if isRequired {
                    Text("*")
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(.red)
                }
            }

            // Phone input row
            HStack(spacing: 8) {

                // Country code picker with Menu
                Menu {
                    ForEach(countries, id: \.id) { country in
                        Button(action: {
                            countryCode = country
                        }) {
                            HStack {
                                Text(country.name)
                                Text(country.key ?? "")
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 8) {
                        CountryFlagView(imagePath: countryCode?.image)
                            .frame(width: 32, height: 24)
                            .cornerRadius(4)
                        Text(countryCode?.key ?? "+966")
                            .expoSystemFont(size: FontSize.normal, weight: .medium)
                            .foregroundColor(.black)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 56)
                    .glassyBackground(cornerRadius: 12)
                }

                // Phone number text field
                HStack {
                    FixedTextField(
                        placeholder: "Phone number".localized,
                        keyboardType: .phonePad,
                        text: $phone
                    )
                }
                .padding(.horizontal, 16)
                .frame(height: 56)
                .glassyBackground(cornerRadius: 12)
            }

            // Error message
            if shouldShowError {
                Text(displayError ?? "")
                    .expoSystemFont(size: FontSize.small, weight: .regular)
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Phone Format Helper
    /// Formats phone number for API (ensures 5XXXXXXXX format without leading 0)
    static func formatPhoneForApi(_ phone: String, countryCode: String?) -> String {
        var formatted = phone.trimmingCharacters(in: .whitespaces)
        // Remove +966 or 966 prefix if present
        if let code = countryCode?.replacingOccurrences(of: "+", with: "") {
            formatted = formatted.replacingOccurrences(of: "+\(code)", with: "")
            formatted = formatted.replacingOccurrences(of: code, with: "")
        }
        // Remove leading 0 if present
        if formatted.hasPrefix("0") {
            formatted = String(formatted.dropFirst())
        }
        return formatted
    }

    // MARK: - Country Code Helper
    /// Returns the country code key from Country object, defaulting to "+966" if nil
    static func getCountryCodeOrDefault(_ country: Country?) -> String {
        guard let key = country?.key, !key.isEmpty else {
            return "+966"
        }
        return key
    }

    /// Returns the country code string, defaulting to "+966" if nil or empty
    static func getCountryCodeOrDefault(_ countryCode: String?) -> String {
        guard let code = countryCode, !code.isEmpty else {
            return "+966"
        }
        return code
    }
}
