//
//  FilterSelectionView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

enum FilterSelectionType {
    case carModels
    case cities
}

struct FilterSelectionView: View {

    let type: FilterSelectionType
    let carModels: [CarModel]
    let cities: [FilterCity]
    @Binding var selectedCarTypeIds: Set<Int>
    @Binding var selectedCityIds: Set<Int>
    var onDismiss: () -> Void
    var onConfirm: () -> Void

    @State private var searchText: String = ""

    private var title: String {
        switch type {
        case .carModels:
            return "types_and_models".localized
        case .cities:
            return "cities".localized
        }
    }

    private var searchPlaceholder: String {
        switch type {
        case .carModels:
            return "search_car_type".localized
        case .cities:
            return "search_city".localized
        }
    }

    private var filteredCarModels: [CarModel] {
        guard !searchText.isEmpty else { return carModels }
        return carModels.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    private var filteredCities: [FilterCity] {
        guard !searchText.isEmpty else { return cities }
        return cities.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    private var selectedCount: Int {
        switch type {
        case .carModels:
            return selectedCarTypeIds.count
        case .cities:
            return selectedCityIds.count
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView

            // Search bar
            searchBarView

            // List
            listView

            // Confirm button
            confirmButton
        }
        .background(Color(.systemGroupedBackground))
        .logViewAppearance()
    }

    // MARK: - Header View
    private var headerView: some View {
        HStack {
            Button {
                onDismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.black)
            }

            Spacer()

            Text(title)
                .expoSystemFont(size: FontSize.large, weight: .bold)
                .foregroundColor(.black)

            Spacer()

            // Placeholder for balance
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.clear)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.white)
    }

    // MARK: - Search Bar
    private var searchBarView: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .font(.system(size: 16))

            TextField(searchPlaceholder, text: $searchText)
                .expoSystemFont(size: FontSize.small, weight: .regular)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - List View
    private var listView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                switch type {
                case .carModels:
                    ForEach(filteredCarModels) { model in
                        selectionRow(
                            title: model.name,
                            isSelected: selectedCarTypeIds.contains(model.id),
                            onTap: {
                                if selectedCarTypeIds.contains(model.id) {
                                    selectedCarTypeIds.remove(model.id)
                                } else {
                                    selectedCarTypeIds.insert(model.id)
                                }
                            }
                        )
                    }

                case .cities:
                    ForEach(filteredCities) { city in
                        selectionRow(
                            title: city.name,
                            isSelected: selectedCityIds.contains(city.id),
                            onTap: {
                                if selectedCityIds.contains(city.id) {
                                    selectedCityIds.remove(city.id)
                                } else {
                                    selectedCityIds.insert(city.id)
                                }
                            }
                        )
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Selection Row
    private func selectionRow(title: String, isSelected: Bool, onTap: @escaping () -> Void) -> some View {
        Button {
            onTap()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? .mainColor : .gray)

                Text(title)
                    .expoSystemFont(size: FontSize.small, weight: .regular)
                    .foregroundColor(.black)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .background(Color.white)
    }

    // MARK: - Confirm Button
    private var confirmButton: some View {
        MainButton(
            title: confirmButtonTitle,
            action: {
                onConfirm()
            }
        )
        .padding(.vertical, 16)
    }

    private var confirmButtonTitle: String {
        if selectedCount > 0 {
            return "confirm".localized + " (\(selectedCount) " + "selected".localized + ")"
        }
        return "confirm".localized
    }
}

#Preview {
    FilterSelectionView(
        type: .carModels,
        carModels: [
            CarModel(id: 1, name: "Toyota"),
            CarModel(id: 2, name: "Honda"),
            CarModel(id: 3, name: "BMW")
        ],
        cities: [],
        selectedCarTypeIds: .constant([1]),
        selectedCityIds: .constant([]),
        onDismiss: {},
        onConfirm: {}
    )
}
