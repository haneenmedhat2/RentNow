//
//  IntroViewModel.swift
//  RentNow
//
//  Created by Claude on 22/01/2026.
//

import SwiftUI
import Combine

class IntroViewModel: BaseViewModel {

    // MARK: - Published Properties
    @Published var currentPageIndex: Int = 0
    @Published var splashScreens: [SplashScreenModel] = []
    @Published var isDataLoaded: Bool = false

    // MARK: - Computed Properties
    var isLastPage: Bool {
        currentPageIndex == splashScreens.count - 1
    }

    var isFirstPage: Bool {
        currentPageIndex == 0
    }

    var totalPages: Int {
        splashScreens.count
    }

    // MARK: - Init
    override init(responseHandler: ResponseHandler = DefaultResponseHandler()) {
        super.init(responseHandler: responseHandler)
        // Set loading to true immediately to prevent race condition
        isLoading = true
        fetchSplashScreens()
    }

    // MARK: - API Call
    @MainActor
    func fetchSplashScreens() {
        Task {
            showIndicator()
            let endPoint = IntroEndpoint.getActiveSplashScreens()

            do {
                let response = try await requestFullResponse(endPoint)
                if let data = response.data {
                    // Sort by orderBy field
                    self.splashScreens = data.sorted { ($0.orderBy ?? 0) < ($1.orderBy ?? 0) }
                    self.isDataLoaded = true
                }
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }

    // MARK: - Navigation Methods
    func nextPage() {
        guard currentPageIndex < splashScreens.count - 1 else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentPageIndex += 1
        }
    }

    func previousPage() {
        guard currentPageIndex > 0 else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentPageIndex -= 1
        }
    }

    func goToPage(_ index: Int) {
        guard index >= 0 && index < splashScreens.count else { return }
        withAnimation(.easeInOut(duration: 0.3)) {
            currentPageIndex = index
        }
    }
}
