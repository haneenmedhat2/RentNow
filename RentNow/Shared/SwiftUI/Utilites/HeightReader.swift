//
//  HeightReader.swift
//  Holool
//
//  Created by Elshamy on 16/11/2025.
//

import SwiftUI

struct HeightReader: View {
    var body: some View {
        GeometryReader { geo in
            Color.clear.preference(key: ContentHeightKey.self, value: geo.size.height)
        }
    }
}

struct ContentHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
