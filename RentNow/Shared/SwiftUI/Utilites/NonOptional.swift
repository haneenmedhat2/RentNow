//
//  File.swift
//  Holool
//
//  Created by Elshamy on 16/11/2025.
//

import SwiftUI
extension Binding where Value == String? {
    var nonOptional: Binding<String> {
        Binding<String>(
            get: { self.wrappedValue ?? "" },
            set: { self.wrappedValue = $0 }
        )
    }
}

extension Binding where Value == Bool? {
    var nonOptionalBool : Binding<Bool> {
        Binding<Bool>(
            get: { self.wrappedValue ?? false },
            set: { self.wrappedValue = $0 }
        )
    }
}
