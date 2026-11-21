//
//  MyAdDetailsViewModel.swift
//  RentNow
//
//  Created by Claude Code
//

import Foundation
import Combine

enum MyAdStatus {
    case underReview
    case approved
    case rejected
}

@MainActor
final class MyAdDetailsViewModel: BaseViewModel {

    let adId: Int
    let filterType: MyAdFilterType
    @Published var details: MyAdDetailsData?
    @Published var isDeleted = false
    @Published var isAvailable: Bool = false

    init(adId: Int, filterType: MyAdFilterType) {
        self.adId = adId
        self.filterType = filterType
    }

    // MARK: - Ad Status

    var adStatus: MyAdStatus {
        switch filterType {
        case .underReview:
            return .underReview
        case .approved:
            return .approved
        case .rejectedWithNotes:
            return .rejected
        }
    }

    // MARK: - Computed Properties

    var sliderImages: [ImageData] {
        guard let details = details, let images = details.images else { return [] }
        return images.enumerated().map { index, url in
            ImageData(imageID: index, image: url, id: index, name: nil, description: nil)
        }
    }

    var hasValidLocation: Bool {
        guard let details = details else { return false }
        return (details.latitude ?? 0) != 0 && (details.longitude ?? 0) != 0
    }

    // MARK: - Methods

    func fetchDetails() async {
        showIndicator()

        do {
            let response = try await request(MoreEndpoint.getMyAdDetails(id: adId))
            self.details = response
            self.isAvailable = response?.isAvailableForOrdering ?? false
        } catch {
            showError(error.localizedDescription)
        }

        hideIndicator()
    }

    func toggleAvailability() async {
        do {
            let _ = try await request(MoreEndpoint.toggleAdAvailability(id: adId))
            isAvailable.toggle()
        } catch {
            showError(error.localizedDescription)
        }
    }

    func deleteAd() async {
        showIndicator()

        do {
            let _ = try await request(MoreEndpoint.deleteAd(id: adId))
            isDeleted = true
        } catch {
            showError(error.localizedDescription)
        }

        hideIndicator()
    }

    func openLocation() {
        guard hasValidLocation, let details = details else { return }
        MapHelper.openLocation(
            latitude: details.latitude ?? 0,
            longitude: details.longitude ?? 0,
            label: details.geoAddress ?? ""
        )
    }
}
