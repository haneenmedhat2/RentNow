//
//  Array.swift
//  App
//
//  Created by MGAbouarab on 27/02/2024.
//

import Foundation

public extension Array where Element: Encodable {
    func toString() -> String {
        do {
            let encodedData = try JSONEncoder().encode(self)
            let stringModel = String(data: encodedData, encoding: .utf8)
            return stringModel ?? "[]"
        } catch {
            return "[]"
        }
    }
}

