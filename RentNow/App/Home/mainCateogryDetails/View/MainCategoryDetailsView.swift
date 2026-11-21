//
//  MainCategoryDetailsView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct MainCategoryDetailsView: View {

    let coordinator: HomeCoordinatorProtocol
    @ObservedObject var viewModel: MainCategoryDetailsViewModel

    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true) {
            VStack(spacing: 0) {
                MainCategoryDetailsSearchBarView(
                    searchText: $viewModel.searchText,
                    hasActiveFilters: viewModel.hasActiveFilters,
                    onFilterTap: {
                        coordinator.showFilterSheet(
                            mainCategoryId: viewModel.categoryId,
                            searchQuery: viewModel.searchText,
                            existingParams: viewModel.filterParams,
                            onApply: { params in
                                viewModel.applyFilters(params)
                            }
                        )
                    }
                )

                if !viewModel.subCategories.isEmpty {
                    MainCategoryDetailsSubcategoryChipsView(
                        subCategories: viewModel.subCategories,
                        selectedId: viewModel.selectedSubCategoryId,
                        onSelect: { id in
                            viewModel.selectSubCategory(id)
                        }
                    )
                }

                ScrollView {
                    if !viewModel.filteredAdvertisements.isEmpty {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 0),
                            GridItem(.flexible(), spacing: 0)
                        ], spacing: 4) {
                            ForEach(viewModel.filteredAdvertisements) { ad in
                                MainCategoryDetailsCarCardView(advertisement: ad)
                                    .padding(6)
                                    .onTapGesture {
                                        coordinator.showCarDetails(carId: ad.id)
                                    }
                            }
                            if viewModel.filteredAdvertisements.count % 2 != 0 {
                                Color.clear
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "car.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.5))

                            Text("search_no_results".localized)
                                .expoSystemFont(size: FontSize.large, weight: .medium)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 100)
                    }
                }
                .refreshable {
                    await viewModel.fetchSearchResults()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.categoryName)
        .task {
            await viewModel.fetchSearchResults()
        }
    }
}

#Preview {
    NavigationStack {
        MainCategoryDetailsView(
            coordinator: HomeCoordinator(),
            viewModel: MainCategoryDetailsViewModel(categoryId: 1, categoryName: "Luxury Cars")
        )
    }
}
