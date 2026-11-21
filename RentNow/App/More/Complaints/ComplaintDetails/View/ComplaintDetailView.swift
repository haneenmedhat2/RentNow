//
//  ComplaintDetailView.swift
//  RentNow
//

import SwiftUI

struct ComplaintDetailView: View {

    let coordinator: MoreCoordinatorProtocol
    @ObservedObject var viewModel: ComplaintDetailViewModel

    var body: some View {
        BaseView(viewModel: viewModel) {
            if let detail = viewModel.detail {
                ScrollView {
                    VStack(spacing: 16) {
                        ComplaintDetailInfoCardView(detail: detail)
                        ComplaintDetailContentCardView(detail: detail, onImageTap: {
                            if let attachment = detail.attachment, !attachment.isEmpty {
                                viewModel.mediaViewerManager.prefetchAndShowImage(NetworkConstants.domain + attachment)
                            }
                        })
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
        }
        .mediaViewer(viewModel.mediaViewerManager)
        .navigationTitle("Complaint Details".localized)
        .task {
            await viewModel.fetchComplaintDetail()
        }
    }
}
