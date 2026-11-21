//
//  GeneralPickerField.swift
//  Holool
//
//  Created by Elshamy on 09/11/2025.
//
import SwiftUI
import SwiftUI

struct AppPickerField<Item: GeneralPickerModel>: View {
    let title: String
    let imageName: String
    let items: [Item]
    @Binding var selectedItem: Item?
    @Binding var selectedItems: [Item]
    let errorMessage: String
    let multiSelect: Bool
    let isRequired: Bool

    @State private var showSheet = false
    @State private var searchText = ""

    init(
        title: String,
        imageName: String = "",
        items: [Item],
        selectedItem: Binding<Item?> = .constant(nil),
        selectedItems: Binding<[Item]> = .constant([]),
        errorMessage: String = "",
        multiSelect: Bool = false,
        isRequired: Bool = false
    ) {
        self.title = title
        self.imageName = imageName
        self.items = items
        self._selectedItem = selectedItem
        self._selectedItems = selectedItems
        self.errorMessage = errorMessage
        self.multiSelect = multiSelect
        self.isRequired = isRequired
    }

    private var filteredItems: [Item] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }

    private var displayText: String {
        if multiSelect {
            if selectedItems.isEmpty {
                return title.lowercased()
            } else {
                return selectedItems.map { $0.name }.joined(separator: ", ")
            }
        } else {
            return selectedItem?.name ?? title.lowercased()
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title with required indicator
            HStack(spacing: 4) {
                Text(title)
                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                    .foregroundColor(.black)

                if isRequired {
                    Text("*")
                        .expoSystemFont(size: FontSize.normal, weight: .medium)
                        .foregroundColor(.red)
                }
            }

            VStack(spacing: 0) {
                HStack {
                    if imageName != "" {
                        Image(imageName)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }

                    Text(displayText)
                       .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor((multiSelect ? selectedItems.isEmpty : selectedItem == nil) ? .placeholder : .black)

                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .glassyBackground(cornerRadius: 12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(
                    !errorMessage.isEmpty ? Color.red : Color.clear,
                    lineWidth: 0.7
                ))
                .onTapGesture {
                    showSheet = true
                }

                if !errorMessage.isEmpty {
                    HStack {
                        Text(errorMessage)
                           .expoSystemFont(size: FontSize.small, weight: .medium)
                            .foregroundColor(.red)
                            .padding(8)
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 16)

        .sheet(isPresented: $showSheet) {
            PickerSheetView(
                title: title,
                items: items,
                selectedItem: $selectedItem,
                selectedItems: $selectedItems,
                searchText: $searchText,
                multiSelect: multiSelect
            )
        }
    }
}
