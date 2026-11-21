//
//  CreateReportView.swift
//  RentNow
//

import SwiftUI
import CoreLocation

struct CreateReportView: View {

    let coordinator: OrdersCoordinatorProtocol
    @ObservedObject var viewModel: CreateReportViewModel

    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true) {
          
                VStack(spacing: 16) {
                    AppDatePickerField(
                        title: "Incident Date".localized,
                        image: "calender",
                        placeHolder: "Select Incident Date".localized,
                        mode: .date,
                        maximumDate: Date(),
                        text: $viewModel.incidentDate,
                        textError: $viewModel.incidentDateError
                    )
                    .onChange(of: viewModel.incidentDate) { _ in
                        viewModel.incidentDateError = nil
                    }

                    AppDatePickerField(
                        title: "Incident Time".localized,
                        image: "clock",
                        placeHolder: "Select Incident Time".localized,
                        mode: .time,
                        text: $viewModel.incidentTime,
                        textError: $viewModel.incidentTimeError
                    )
                    .onChange(of: viewModel.incidentTime) { _ in
                        viewModel.incidentTimeError = nil
                    }

                    // Location field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Incident Location".localized)
                            .expoSystemFont(size: FontSize.normal, weight: .medium)

                        Button {
                            coordinator.showReportLocationPicker { [weak viewModel] coordinate, address in
                                viewModel?.setLocation(
                                    address: address,
                                    latitude: coordinate?.latitude ?? 0,
                                    longitude: coordinate?.longitude ?? 0
                                )
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Text(viewModel.location.isEmpty ? "Select Incident Location".localized : viewModel.location)
                                    .expoSystemFont(size: FontSize.normal, weight: .regular)
                                    .foregroundColor(viewModel.location.isEmpty ? Color.gray.opacity(0.6) : .black)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Spacer()

                                Image(systemName: "location.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .glassyBackground(cornerRadius: 12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(
                                (viewModel.locationError != nil) ? Color.red : Color.clear,
                                lineWidth: 0.7
                            ))
                        }
                        .buttonStyle(PlainButtonStyle())

                        if viewModel.locationError != nil {
                            HStack {
                                Text(viewModel.locationError ?? "")
                                    .expoSystemFont(size: FontSize.normal, weight: .medium)
                                    .foregroundColor(.red)
                                    .padding(8)
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 16)

                    AppTextView(
                        title: "Issuing Authority".localized,
                        image: "",
                        placeHolder: "Enter Issuing Authority".localized,
                        text: $viewModel.issuingAuthority,
                        textError: $viewModel.issuingAuthorityError
                    )
                    .onChange(of: viewModel.issuingAuthority) { _ in
                        viewModel.issuingAuthorityError = nil
                    }

                    AppDocumentPickerField(
                        title: "Attach Report".localized,
                        documentURL: $viewModel.documentURL,
                        documentName: $viewModel.documentName,
                        documentError: $viewModel.documentError
                    )

                    MainButton(title: "Confirm Send".localized) {
                        viewModel.submitReport()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    Spacer()
                }
                .padding(.top, 16)
            
        }
        .navigationTitle("Add New Report".localized)
    }
}

#Preview {
    CreateReportView(coordinator: OrdersCoordinator(), viewModel: CreateReportViewModel(orderId: 0))
}
