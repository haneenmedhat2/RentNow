//
//  ReportsView.swift
//  RentNow
//

import SwiftUI

struct ReportsView: View {

    let coordinator: MoreCoordinatorProtocol
    @ObservedObject var viewModel: ReportsViewModel

    var body: some View {
        BaseView(viewModel: viewModel) {
            if viewModel.isEmpty {
                VStack {
                    Spacer()
                    Text("No reports yet".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor(.black.opacity(0.6))
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(Array(viewModel.reports.enumerated()), id: \.offset) { _, item in
                        ReportCardView(item: item) {
                            coordinator.showReportDetails(reportId: item.id ?? 0)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            Spacer()
        }
        .navigationTitle("Reports".localized)
        .task {
            await viewModel.fetchReports()
        }
        .refreshable {
            await viewModel.refreshReports()
        }
    }
}
