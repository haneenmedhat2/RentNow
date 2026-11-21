//
//  FilterSheetView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct FilterSheetView: View {

    @ObservedObject var viewModel: FilterSheetViewModel
    var onDismiss: () -> Void
    var onConfirm: (FilterParams) -> Void
    var onShowCarModelsPicker: () -> Void
    var onShowCitiesPicker: () -> Void

    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true) {
            VStack(spacing: 0) {
                // Header
                headerView

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        // Subcategories Section
                        if !viewModel.subCategories.isEmpty {
                            subCategoriesSection

                            Divider()
                                .frame(height: 1.5)
                                .overlay(.white)
                        }

                        // Car Models Section
                        carModelsSection

                        Divider()
                            .frame(height: 1.5)
                            .overlay(.white)

                        // Fuel Types Section
                        fuelTypesSection
                        
                        Divider()
                            .frame(height: 1.5)
                            .overlay(.white)

                        // Cities Section
                        citiesSection

                        // Price Range Section
                        priceRangeSection

                        // Additional Features Section
                        if !viewModel.additionalFeatures.isEmpty {
                            Divider()
                                .frame(height: 1.5)
                                .overlay(.text)
                            additionalFeaturesSection
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                }

                // Confirm Button
                confirmButton
            }
        }
        .task {
            await viewModel.fetchFilterData()
        }
    }

    // MARK: - Header View
    private var headerView: some View {
        HStack {
            Button {
                onDismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
            }

            Spacer()

            Text("filter_title".localized)
                .expoSystemFont(size: FontSize.large, weight: .semiBold)
                .foregroundColor(.black)

            Spacer()

            // Reset button
            if viewModel.hasActiveFilters {
                Button {
                    viewModel.resetFilters()
                } label: {
                    Text("reset".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(.mainColor)
                }
            } else {
                // Placeholder to balance header
                Text("reset".localized)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.clear)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }

    // MARK: - Subcategories Section
    private var subCategoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            FilterSectionHeaderView(title: "subcategory".localized)

            ForEach(viewModel.subCategories) { subCategory in
                FilterCheckboxRowView(
                    title: subCategory.name,
                    isSelected: viewModel.selectedSubCategoryId == subCategory.id,
                    onTap: {
                        viewModel.toggleSubCategory(subCategory.id)
                    }
                )
            }
        }
    }

    // MARK: - Car Models Section
    private var carModelsSection: some View {
        FilterSelectionRowView(
            mainTitle: "Car model".localized, title: "types_and_models".localized,
            selectAllTitle: "select_all_models".localized,
            selectedCount: viewModel.selectedCarTypeIds.count,
            totalCount: viewModel.carModels.count,
            onRowTap: {
                onShowCarModelsPicker()
            },
            onSelectAllTap: {
                viewModel.selectAllCarModels()
            }
        )
    }

    // MARK: - Fuel Types Section
    private var fuelTypesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            FilterSectionHeaderView(title: "fuel_type".localized)

            ForEach(viewModel.fuelTypes) { fuelType in
                FilterCheckboxRowView(
                    title: fuelType.name,
                    isSelected: viewModel.selectedFuelTypes.contains(fuelType.value),
                    onTap: {
                        viewModel.toggleFuelType(fuelType.value)
                    }
                )
            }
        }
    }

    // MARK: - Cities Section
    private var citiesSection: some View {
        FilterSelectionRowView(
            mainTitle: "city".localized, title: "cities".localized,
            selectAllTitle: "select_all_cities".localized,
            selectedCount: viewModel.selectedCityIds.count,
            totalCount: viewModel.cities.count,
            onRowTap: {
                onShowCitiesPicker()
            },
            onSelectAllTap: {
                viewModel.selectAllCities()
            }
        )
    }

    // MARK: - Price Range Section
    private var priceRangeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            FilterSectionHeaderView(title: "cost".localized)

            FilterPriceRangeView(
                minValue: $viewModel.selectedMinPrice,
                maxValue: $viewModel.selectedMaxPrice,
                isActive: $viewModel.isPriceFilterActive,
                minLimit: viewModel.minPriceLimit,
                maxLimit: viewModel.maxPriceLimit
            )
        }
    }

    // MARK: - Additional Features Section
    private var additionalFeaturesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            FilterSectionHeaderView(title: "additional_features".localized)

            ForEach(viewModel.additionalFeatures) { feature in
                FilterCheckboxRowView(
                    title: feature.name,
                    isSelected: viewModel.selectedAdditionalFeatureIds.contains(feature.id),
                    onTap: {
                        viewModel.toggleAdditionalFeature(feature.id)
                    }
                )
            }
        }
    }

    // MARK: - Confirm Button
    private var confirmButton: some View {
        MainButton(
            title: confirmButtonTitle,
            action: {
                onConfirm(viewModel.filterParams)
            }
        )
        .padding(.vertical, 16)
    }

    private var confirmButtonTitle: String {
        let count = viewModel.selectedCount
        if count > 0 {
            return "confirm".localized + " (\(count) " + "selected".localized + ")"
        }
        return "confirm".localized
    }
}

