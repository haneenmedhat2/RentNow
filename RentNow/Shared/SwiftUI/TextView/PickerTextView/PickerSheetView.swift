//
//  PickerSheetView.swift
//  Holool
//
//  Created by Elshamy on 09/11/2025.
//
import SwiftUI

struct PickerSheetView<Item: GeneralPickerModel>: View {
    let title: String
    let items: [Item]
    @Binding var selectedItem: Item?
    @Binding var selectedItems: [Item]
    @Binding var searchText: String
    let multiSelect: Bool

    @State var localItem: Item?
    @State var localItems: [Item] = []

    @Environment(\.dismiss) private var dismiss

    init(
        title: String,
        items: [Item],
        selectedItem: Binding<Item?> = .constant(nil),
        selectedItems: Binding<[Item]> = .constant([]),
        searchText: Binding<String>,
        multiSelect: Bool = false
    ) {
        self.title = title
        self.items = items
        self._selectedItem = selectedItem
        self._selectedItems = selectedItems
        self._searchText = searchText
        self.multiSelect = multiSelect
        self._localItems = State(initialValue: selectedItems.wrappedValue)
    }

    private var filteredItems: [Item] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        
        
        NavigationView {
            VStack(spacing: 8) {
                HStack {
                    FixedTextField(
                        placeholder: String(format: "Search by %@".localized, title),
                        keyboardType: .default,
                        text: $searchText
                    )
                }
                .padding(10)
                .frame(height: 40)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .padding(.horizontal)
                
                Divider().padding(.vertical, 8)
                
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(filteredItems) { item in
                            Button {
                                if multiSelect {
                                    toggleSelection(item)
                                } else {
                                    localItem = item
                                }
                            } label: {
                                HStack {
                                    Text(item.name)
                                        .foregroundColor(.black)
                                    Spacer()
                                    if multiSelect {
                                        if localItems.contains(where: { $0.id == item.id }) {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.green)
                                        }
                                    } else {
                                        if localItem == item {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.green)
                                        }
                                    }
                                }
                                .padding()
                            }
                            Divider()
                        }
                    }
                }
                
                .padding()
                MainButton(title: "Confirm".localized) {
                    if multiSelect {
                        selectedItems = localItems
                        dismiss()
                    } else {
                        guard localItem != nil else {
                            ToastManager.shared.show(message: "Please select an item".localized, type: .error)
                            return
                        }
                        selectedItem = localItem
                        dismiss()
                    }
                }

                Spacer()
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .withGlobalToast()
    }

    private func toggleSelection(_ item: Item) {
        if let index = localItems.firstIndex(where: { $0.id == item.id }) {
            localItems.remove(at: index)
        } else {
            localItems.append(item)
        }
    }
}
