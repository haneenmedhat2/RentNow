//
//  ReportModel.swift
//  RentNow
//

import Foundation

struct ReportItem: Codable, Identifiable {
    let id: Int?
    let orderId: Int?
    let incidentDate: String?
    let incidentDateFormatted: String?
    let latitude: Double?
    let longitude: Double?
    let geoAddress: String?
    let incidentReportIssuer: String?
    let incidentReportsUrls: [String]?
    let createdByUserId: String?
    let creationDate: String?
    let orderStatus: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.orderId = try container.decodeIfPresent(Int.self, forKey: .orderId)
        self.incidentDate = try container.decodeIfPresent(String.self, forKey: .incidentDate) ?? ""
        self.incidentDateFormatted = try container.decodeIfPresent(String.self, forKey: .incidentDateFormatted) ?? ""
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0.0
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0.0
        self.geoAddress = try container.decodeIfPresent(String.self, forKey: .geoAddress) ?? ""
        self.incidentReportIssuer = try container.decodeIfPresent(String.self, forKey: .incidentReportIssuer) ?? ""
        self.incidentReportsUrls = try container.decodeIfPresent([String].self, forKey: .incidentReportsUrls) ?? []
        self.createdByUserId = try container.decodeIfPresent(String.self, forKey: .createdByUserId)
        self.creationDate = try container.decodeIfPresent(String.self, forKey: .creationDate) ?? ""
        self.orderStatus = try container.decodeIfPresent(String.self, forKey: .orderStatus) ?? ""
    }
}

struct ReportDetailData: Codable {
    let id: Int?
    let orderId: Int?
    let incidentDate: String?
    let incidentDateFormatted: String?
    let latitude: Double?
    let longitude: Double?
    let geoAddress: String?
    let incidentReportIssuer: String?
    let incidentReportsUrls: [String]?
    let createdByUserId: String?
    let creationDate: String?
    let orderStatus: String?
    let orderStatusName: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.orderId = try container.decodeIfPresent(Int.self, forKey: .orderId)
        self.incidentDate = try container.decodeIfPresent(String.self, forKey: .incidentDate) ?? ""
        self.incidentDateFormatted = try container.decodeIfPresent(String.self, forKey: .incidentDateFormatted) ?? ""
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0.0
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0.0
        self.geoAddress = try container.decodeIfPresent(String.self, forKey: .geoAddress) ?? ""
        self.incidentReportIssuer = try container.decodeIfPresent(String.self, forKey: .incidentReportIssuer) ?? ""
        self.incidentReportsUrls = try container.decodeIfPresent([String].self, forKey: .incidentReportsUrls) ?? []
        self.createdByUserId = try container.decodeIfPresent(String.self, forKey: .createdByUserId)
        self.creationDate = try container.decodeIfPresent(String.self, forKey: .creationDate) ?? ""
        self.orderStatus = try container.decodeIfPresent(String.self, forKey: .orderStatus) ?? ""
        self.orderStatusName = try container.decodeIfPresent(String.self, forKey: .orderStatusName) ?? ""
    }
}
