//
//  SegmentOption.swift
//  Holool
//
//  Created by Elshamy on 02/12/2025.
//


struct SegmentOption {
    let title: String
    let value: PricePolicy
    
    init(title: String, value: PricePolicy) {
        self.title = title
        self.value = value
    }
}

enum PricePolicy: String, Codable {
    case offers = "offers"
    case admin = "admin"
}
