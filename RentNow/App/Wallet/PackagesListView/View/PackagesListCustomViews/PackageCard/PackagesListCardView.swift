//
//  PackagesListCardView.swift
//  RentNow
//
//  Created by Claude on 2026-02-08.
//

import SwiftUI

struct PackagesListCardView: View {

    let package: PackageItem
    let durationText: String
    var onSubscribeTap: () -> Void

    private var descriptionText: String {
        let localized = Language.isRTL() ? (package.descriptionAr ?? "") : (package.descriptionEn ?? "")
        return localized.isEmpty ? (package.description ?? "") : localized
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Upper section
            VStack(alignment: .leading, spacing: 8) {
                // Header: name + duration badge
                HStack(spacing: 8) {
                    Text(package.name ?? "")
                        .expoSystemFont(size: FontSize.large, weight: .medium)
                        .foregroundColor(Color(hex: "#080808"))

                    Spacer()

                    Text(durationText)
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor(Color(hex: "#121212"))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(Color(hex: "#d1f3ff"))
                        .cornerRadius(2)
                }

                // Price with Riyal symbol
                HStack(spacing: 4) {
                    Text(String(format: "%.0f", package.price ?? 0))
                        .expoSystemFont(size: 24, weight: .semiBold)
                        .foregroundColor(Color(hex: "#022a60"))

                    Text("SAR".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(Color(hex: "#022a60"))
                }

                // Description
                if !descriptionText.isEmpty {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Actual package description".localized)
                            .expoSystemFont(size: FontSize.small, weight: .semiBold)
                            .foregroundColor(Color(hex: "#454545"))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text(descriptionText)
                            .expoSystemFont(size: FontSize.small, weight: .regular)
                            .foregroundColor(Color(hex: "#454545"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                // Details
                VStack(spacing: 6) {
                    // Free operations count
//                    HStack(spacing: 6) {
//                        Text("Free operations count".localized)
//                            .expoSystemFont(size: FontSize.small, weight: .medium)
//                            .foregroundColor(Color(hex: "#454545"))
//
//                        Spacer()
//
//                        Text("\(package.freeOperationsCount ?? 0)")
//                            .expoSystemFont(size: FontSize.small, weight: .medium)
//                            .foregroundColor(Color(hex: "#121212"))
//                    }

                    // Number of free delivery times
                    HStack(spacing: 6) {
                        Text("Number of free delivery times".localized)
                            .expoSystemFont(size: FontSize.small, weight: .medium)
                            .foregroundColor(Color(hex: "#454545"))

                        Spacer()

                        Text("\(package.waivedDeliveryFeesOrdersCount ?? 0)")
                            .expoSystemFont(size: FontSize.small, weight: .medium)
                            .foregroundColor(Color(hex: "#121212"))
                    }

                    // Discount percentage
                    HStack(spacing: 6) {
                        Text("Discount percentage".localized)
                            .expoSystemFont(size: FontSize.small, weight: .medium)
                            .foregroundColor(Color(hex: "#454545"))

                        Spacer()

                        Text(String(format: "%.0f%%", package.discountPercentage ?? 0))
                            .expoSystemFont(size: FontSize.small, weight: .medium)
                            .foregroundColor(Color(hex: "#121212"))
                    }
                }
            }

            // Subscribe button
            DarkBluePillButton(
                title: "Subscribe now".localized,
                height: 32,
                fontSize: FontSize.small
            ) {
                onSubscribeTap()
            }
        }
        .padding(12)
        .background(Color.white.opacity(0.24))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color(hex: "#eaf9ff"), lineWidth: 1)
        )
        .cornerRadius(4)
    }
}

#Preview {
    PackagesListCardView(
        package: PackageItem.preview,
        durationText: "3 months",
        onSubscribeTap: {}
    )
    .padding()
}

// MARK: - Preview Helper
private extension PackageItem {
    static var preview: PackageItem {
        try! PackageItem(from: PreviewDecoder())
    }
}

private struct PreviewDecoder: Decoder {
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey: Any] = [:]
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        KeyedDecodingContainer(PreviewKeyedContainer())
    }
    func unkeyedContainer() throws -> UnkeyedDecodingContainer { fatalError() }
    func singleValueContainer() throws -> SingleValueDecodingContainer { fatalError() }
}

private struct PreviewKeyedContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    var codingPath: [CodingKey] = []
    var allKeys: [Key] = []
    func contains(_ key: Key) -> Bool { false }
    func decodeNil(forKey key: Key) throws -> Bool { true }
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable { throw DecodingError.keyNotFound(key, .init(codingPath: [], debugDescription: "")) }
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey { fatalError() }
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer { fatalError() }
    func superDecoder() throws -> Decoder { fatalError() }
    func superDecoder(forKey key: Key) throws -> Decoder { fatalError() }
}
