//
//  InfoContentViewModel.swift
//  RentNow
//

import Foundation
import Combine

@MainActor
class InfoContentViewModel: BaseViewModel {

    // MARK: - Properties
    let type: InfoContentType
    @Published var content: String = ""

    var title: String { type.title }

    var isEmpty: Bool {
        content.isEmpty && !isLoading
    }

    // MARK: - Init
    init(type: InfoContentType) {
        self.type = type
    }

    // MARK: - API Calls
    func fetchContent() async {
        showIndicator()
        do {
            switch type {
            case .aboutUs:
                let endpoint = MoreEndpoint.getAboutUs()
                let response = try await request(endpoint)
                content = response?.aboutUs ?? ""
            case .termsAndConditions:
                let endpoint = MoreEndpoint.getTermsAndConditions()
                let response = try await request(endpoint)
                content = response?.termAndCondition ?? ""
            case .cancellationTerms:
                let endpoint = MoreEndpoint.getCancellationTerms()
                let response = try await request(endpoint)
                content = response?.conditions ?? ""
            case .howItWorks:
                let endpoint = MoreEndpoint.getHowItWorks()
                let response = try await request(endpoint)
                content = response?.content ?? ""
            }
        } catch {
            showError(error.localizedDescription)
        }
        hideIndicator()
    }
}
