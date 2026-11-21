//
//  HomeDetailsModel.swift
//  RentNow
//
//  Created by Claude on 2026-01-27.
//

import Foundation

// MARK: - User Info Model
struct UserInfoModel: Codable {
    let name: String?
    let imageUrl: String?
}

// MARK: - Slider Model
struct SliderModel: Codable {
    let id: Int
    let name: String
    let description: String?
    let audienceType: String
    let imageUrl: String
    let validityPeriodInDays: Int
    let isExpired: Bool
}

// MARK: - Main Category Model
struct MainCategoryModel: Codable {
    let id: Int
    let name: String
    let imageUrl: String
    let insuranceValue: Int
}

// MARK: - Home Details Data
struct HomeDetailsData: Codable {
    let userInfo: UserInfoModel?
    let sliders: [SliderModel]
    let mainCategories: [MainCategoryModel]
}

// MARK: - SliderModel to ImageData Extension
extension SliderModel {
    func toImageData() -> ImageData {
        ImageData(
            imageID: id,
            image: imageUrl,
            id: id,
            name: name,
            description: description
        )
    }
}

extension Array where Element == SliderModel {
    func toImageData() -> [ImageData] {
        self.map { $0.toImageData() }
    }
}
