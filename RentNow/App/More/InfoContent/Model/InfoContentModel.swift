//
//  InfoContentModel.swift
//  RentNow
//

import Foundation

// MARK: - Info Content Type
enum InfoContentType {
    case aboutUs
    case termsAndConditions
    case cancellationTerms
    case howItWorks

    var title: String {
        switch self {
        case .aboutUs:
            return "About Rent Now".localized
        case .termsAndConditions:
            return "Terms and Conditions".localized
        case .cancellationTerms:
            return "Cancellation and Delay Terms".localized
        case .howItWorks:
            return "How the App Works".localized
        }
    }

    var emptyMessage: String {
        switch self {
        case .cancellationTerms:
            return "There are no Cancellation and Delay Terms".localized
        default:
            return ""
        }
    }
}

// MARK: - Response Models
struct AboutUsData: Codable {
    let aboutUs: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.aboutUs = try container.decodeIfPresent(String.self, forKey: .aboutUs) ?? ""
    }
}

struct TermsAndConditionsData: Codable {
    let termAndCondition: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.termAndCondition = try container.decodeIfPresent(String.self, forKey: .termAndCondition) ?? ""
    }
}



struct HowItWorksData: Codable {
    let content: String?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.content = try container.decodeIfPresent(String.self, forKey: .content) ?? ""
    }
}
