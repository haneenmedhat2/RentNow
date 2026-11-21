//
//  CountryModel.swift
//  Holool
//
//  Created by Elshamy on 03/11/2025.
//

import Foundation
import Combine

// MARK: - Country
struct Country: Codable, Equatable , GeneralPickerModel{
    var id: Int
    var name: String
    var  key: String?
    var image: String?
    var currency:String?
    var isSelected: Bool = false


    init(id: Int, name: String , key: String? = nil, image: String? = nil, currency: String? = nil, isSelected: Bool = false) {
        self.id = id
        self.name = name
        self.currency = currency
        self.key = key
        self.image = image
        self.isSelected = isSelected
    }

    enum CodingKeys: String, CodingKey {
        case id
        case currency
        case name
        case key
        case image
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.key = try container.decodeIfPresent(String.self, forKey: .key)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.currency = try container.decodeIfPresent(String.self, forKey: .currency)
    }
}
