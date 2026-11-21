//
//  IntroPageModel.swift
//  RentNow
//
//  Created by Claude on 22/01/2026.
//

import Foundation

// MARK: - SplashScreen Model (API Response)
struct SplashScreenModel: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String?
    let imageUrl: String?
    let orderBy: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case imageUrl
        case orderBy
    }
}
