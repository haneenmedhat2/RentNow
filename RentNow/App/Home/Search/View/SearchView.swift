//
//  SearchView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct SearchView: View {

    let coordinator: HomeCoordinatorProtocol
    @ObservedObject var viewModel: SearchViewModel

    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true) {
            VStack(spacing: 0) {
                MainCategoryDetailsSearchBarView(
                    searchText: $viewModel.searchText,
                    hasActiveFilters: viewModel.hasActiveFilters,
                    onFilterTap: {
                        coordinator.showFilterSheet(
                            mainCategoryId: nil,
                            searchQuery: viewModel.searchText,
                            existingParams: viewModel.filterParams,
                            onApply: { params in
                                viewModel.applyFilters(params)
                            }
                        )
                    }
                )

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

                            Text(viewModel.hasSearched ? "search_no_results".localized : "search_start_message".localized)
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
        .navigationTitle("search_title".localized)
    }
}

#Preview {
    NavigationStack {
        SearchView(
            coordinator: HomeCoordinator(),
            viewModel: SearchViewModel()
        )
    }
}
