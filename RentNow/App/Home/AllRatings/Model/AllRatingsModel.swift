//
//  AllRatingsModel.swift
//  RentNow
//

import Foundation

// MARK: - All Ratings Paging Data
struct AllRatingsPagingData: Codable {
    let pagination: AllRatingsPagination?
    let result: [RateData]?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.pagination = try container.decodeIfPresent(AllRatingsPagination.self, forKey: .pagination)
        self.result = try container.decodeIfPresent([RateData].self, forKey: .result) ?? []
    }
}

// MARK: - All Ratings Pagination
struct AllRatingsPagination: Codable {
    let currentPage: Int?
    let totalPages: Int?
    let pageSize: Int?
    let totalCount: Int?
    let hasNextPage: Bool?
    let hasPreviousPage: Bool?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currentPage = try container.decodeIfPresent(Int.self, forKey: .currentPage) ?? 1
        self.totalPages = try container.decodeIfPresent(Int.self, forKey: .totalPages) ?? 1
        self.pageSize = try container.decodeIfPresent(Int.self, forKey: .pageSize) ?? 10
        self.totalCount = try container.decodeIfPresent(Int.self, forKey: .totalCount) ?? 0
        self.hasNextPage = try container.decodeIfPresent(Bool.self, forKey: .hasNextPage)
        self.hasPreviousPage = try container.decodeIfPresent(Bool.self, forKey: .hasPreviousPage)
    }
}
