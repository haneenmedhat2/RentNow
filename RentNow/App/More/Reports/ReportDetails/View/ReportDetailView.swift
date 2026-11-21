//
//  ReportDetailView.swift
//  RentNow
//

import SwiftUI

struct ReportDetailView: View {

    let coordinator: MoreCoordinatorProtocol
    @ObservedObject var viewModel: ReportDetailViewModel

    var body: some View {
        BaseView(viewModel: viewModel) {
            if let detail = viewModel.detail {
                VStack(spacing: 16) {
                    ReportDetailInfoCardView(detail: detail)

                    ReportDetailContentCardView(
                        detail: detail,
                        incidentTime: viewModel.formattedIncidentTime,
                        pdfFileName: viewModel.pdfFileName,
                        onPDFTap: {
                            viewModel.showPDFPreview = true
                        }
                    )
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            Spacer()
        }
        .sheet(isPresented: $viewModel.showPDFPreview) {
            if let url = viewModel.pdfURL {
                QuickLookView(url: url)
            }
        }
        .navigationTitle("Report Details".localized)
        .task {
            await viewModel.fetchReportDetail()
        }
    }
}
