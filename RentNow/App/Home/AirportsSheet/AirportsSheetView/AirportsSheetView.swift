//
//  AirportsSheetView.swift
//  RentNow
//
//  Created by Claude Code
//

import SwiftUI

struct AirportsSheetView: View {
    // MARK: - Properties
    @ObservedObject var viewModel: AirportsSheetViewModel
    var onDismiss: () -> Void
    var onConfirm: () -> Void
    var onOpenMapPicker: () -> Void
    var showMapButton: Bool = true

    // MARK: - Body
    var body: some View {
        BaseView(viewModel: viewModel) {
            VStack(spacing: 0) {
                // Header
                headerView
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 12)

                Divider()

                // Content Area
                if viewModel.isEmpty {
                    EmptyAirportsView {
                        onOpenMapPicker()
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    airportListView
                }

                Divider()

                // Footer Buttons
                footerButtons
                 
            }
            .frame(maxHeight: 500)
        }
    }

    // MARK: - Header View
    private var headerView: some View {
        HStack {
            Button {
                onDismiss()
            } label: {
                Image("closeButton")
                    .frame(width: 40 , height: 40)
            }
            
            Text("airports_sheet_title".localized)
                .expoSystemFont(size: FontSize.large, weight: .bold)
                .foregroundColor(.primary)

            Spacer()

        
        }
    }

    // MARK: - Airport List View
    private var airportListView: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(viewModel.airports) { airport in
                    AirportRadioButtonView(
                        airport: airport,
                        isSelected: viewModel.selectedAirport?.id == airport.id,
                        onTap: {
                            viewModel.selectAirport(airport)
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }

    // MARK: - Footer Buttons
    private var footerButtons: some View {
        VStack(spacing: 12) {

            MainButton(
                title: "confirm".localized,
                action: onConfirm
            )
            .disabled(viewModel.selectedAirport == nil)
            .opacity(viewModel.selectedAirport == nil ? 0.5 : 1.0)

            // Show map button only if not coming from LocationPickerView
            if showMapButton {
                GlassyButton(
                    title: "airports_determine_location".localized,
                    image: "orginalLocation", action: onOpenMapPicker
                )
            }
        }
    }
}
