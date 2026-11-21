//
//  AdvertisementDetailsViewModel.swift
//  RentNow
//

import Foundation
import Combine

@MainActor
final class AdvertisementDetailsViewModel: BaseViewModel {

    let advertisementId: Int
    @Published var details: AdvertisementDetailsData?
    @Published var shouldDismiss: Bool = false
    @Published var showMapPickerDialog: Bool = false

    init(advertisementId: Int) {
        self.advertisementId = advertisementId
        super.init()
        observeAdvertisementStatusChanges()
    }

    private func observeAdvertisementStatusChanges() {
        NotificationCenter.default.addObserver(
            forName: .advertisementStatusChanged,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self else { return }
            let changedId = notification.userInfo?["advertisement_id"] as? Int
            if changedId == self.advertisementId {
                Task { @MainActor in
                    await self.refreshDetails()
                }
            }
        }
    }

    // MARK: - Computed Properties

    var sliderImages: [ImageData] {
        guard let details = details, let images = details.images else { return [] }
        return images.enumerated().map { index, url in
            ImageData(imageID: index, image: url, id: index, name: nil, description: nil)
        }
    }

    var canBook: Bool {
        guard let details = details else { return false }
        return (details.canOrder ?? false) && (details.isAvailableForOrdering ?? false)
    }

    var hasValidLocation: Bool {
        guard let details = details else { return false }
        return (details.latitude ?? 0) != 0 && (details.longitude ?? 0) != 0
    }

    var ratesWithIds: [AdvertisementRate] {
        guard let details = details, let rates = details.latestRates else { return [] }
        return rates.enumerated().map { index, rate in
            var rate = rate
            rate.id = index
            return rate
        }
    }

    // MARK: - Methods

    func fetchDetails() async {
        showIndicator()

        do {
            let response = try await request(HomeEndpoint.getAdvertisementDetails(id: advertisementId))
            self.details = response
        } catch {
            showError(error.localizedDescription)
            shouldDismiss = true
        }

        hideIndicator()
    }

    func refreshDetails() async {
        do {
            let response = try await request(HomeEndpoint.getAdvertisementDetails(id: advertisementId))
            self.details = response
        } catch {
            // silent: don't show an error or dismiss on background refresh failure
        }
    }

    func openLocation() {
        guard hasValidLocation else { return }
        showMapPickerDialog = true
    }

    func openInAppleMaps() {
        guard hasValidLocation, let details = details else { return }
        MapHelper.openLocation(
            latitude: details.latitude ?? 0,
            longitude: details.longitude ?? 0,
            label: details.geoAddress ?? ""
        )
    }

    func openInGoogleMaps() {
        guard hasValidLocation, let details = details else { return }
        MapHelper.openInGoogleMaps(
            latitude: details.latitude ?? 0,
            longitude: details.longitude ?? 0
        )
    }

}
