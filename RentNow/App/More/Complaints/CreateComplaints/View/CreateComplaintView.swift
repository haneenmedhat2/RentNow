//
//  CreateComplaintView.swift
//  RentNow
//

import SwiftUI

struct CreateComplaintView: View {

    let coordinator: MoreCoordinatorProtocol
    @ObservedObject var viewModel: CreateComplaintViewModel

    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true) {
            VStack(spacing: 16) {
                AppTextView(
                    title: "Complaint Title".localized,
                    image: "",
                    placeHolder: "Enter complaint title".localized,
                    text: $viewModel.title,
                    textError: $viewModel.titleError
                )

                AppTextEditor(
                    title: "Complaint Text".localized,
                    placeHolder: "Enter complaint text".localized,
                    text: $viewModel.message,
                    textError: $viewModel.messageError
                )

                AppImagePickerView(
                    title: "Attach Image".localized,
                    mediaType: .photoOnly,
                    maxCount: 1,
                    mediaItems: $viewModel.mediaItems,
                    mediaError: $viewModel.mediaError
                )

                MainButton(title: "Confirm Send".localized) {
                    viewModel.submitComplaint()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                Spacer()
            }
            .padding(.top, 16)
        }
        .navigationTitle("Create New Complaint".localized)
    }
}

#Preview {
    CreateComplaintView(coordinator: MoreCoordinator(), viewModel: CreateComplaintViewModel())
}
