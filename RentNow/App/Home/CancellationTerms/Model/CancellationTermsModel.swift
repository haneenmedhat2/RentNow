//
//  CancellationTermsModel.swift
//  RentNow
//

import Foundation

struct CancellationTermsData: Codable {
    let conditions: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.conditions = try container.decodeIfPresent(String.self, forKey: .conditions) ?? ""
    }
}
 
