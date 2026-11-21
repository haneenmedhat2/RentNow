//
//  FilterContainerView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

enum FilterNavigationState {
    case filter
    case carModelsPicker
    case citiesPicker
}

struct FilterContainerView: View {

    let mainCategoryId: Int?
    let searchQuery: String?
    let existingParams: FilterParams?
    var onDismiss: () -> Void
    var onApply: (FilterParams) -> Void

    @StateObject private var viewModel: FilterSheetViewModel
    @State private var navigationState: FilterNavigationState = .filter

    init(
        mainCategoryId: Int?,
        searchQuery: String?,
        existingParams: FilterParams?,
        onDismiss: @escaping () -> Void,
        onApply: @escaping (FilterParams) -> Void
    ) {
        self.mainCategoryId = mainCategoryId
        self.searchQuery = searchQuery
        self.existingParams = existingParams
        self.onDismiss = onDismiss
        self.onApply = onApply

        _viewModel = StateObject(wrappedValue: FilterSheetViewModel(
            mainCategoryId: mainCategoryId,
            searchQuery: searchQuery,
            existingParams: existingParams
        ))
    }

    var body: some View {
        Group {
            switch navigationState {
            case .filter:
                FilterSheetView(
                    viewModel: viewModel,
                    onDismiss: onDismiss,
                    onConfirm: onApply,
                    onShowCarModelsPicker: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            navigationState = .carModelsPicker
                        }
                    },
                    onShowCitiesPicker: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            navigationState = .citiesPicker
                        }
                    }
                )
                .transition(.opacity)

            case .carModelsPicker:
                FilterSelectionView(
                    type: .carModels,
                    carModels: viewModel.carModels,
                    cities: viewModel.cities,
                    selectedCarTypeIds: $viewModel.selectedCarTypeIds,
                    selectedCityIds: $viewModel.selectedCityIds,
                    onDismiss: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            navigationState = .filter
                        }
                    },
                    onConfirm: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            navigationState = .filter
                        }
                    }
                )
                .transition(.move(edge: .trailing))

            case .citiesPicker:
                FilterSelectionView(
                    type: .cities,
                    carModels: viewModel.carModels,
                    cities: viewModel.cities,
                    selectedCarTypeIds: $viewModel.selectedCarTypeIds,
                    selectedCityIds: $viewModel.selectedCityIds,
                    onDismiss: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            navigationState = .filter
                        }
                    },
                    onConfirm: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            navigationState = .filter
                        }
                    }
                )
                .transition(.move(edge: .trailing))
            }
        }
        .logViewAppearance()
    }
}

#Preview {
    FilterContainerView(
        mainCategoryId: 1,
        searchQuery: nil,
        existingParams: nil,
        onDismiss: {},
        onApply: { _ in }
    )
}
