//
//  ComplaintsView.swift
//  RentNow
//

import SwiftUI

struct ComplaintsView: View {

    let coordinator: MoreCoordinatorProtocol
    @ObservedObject var viewModel: ComplaintsViewModel

    var body: some View {
        BaseView(viewModel: viewModel) {
            if viewModel.isEmpty {
                VStack {
                    Spacer()
                    Text("No complaints yet".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor(.black.opacity(0.6))
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(Array(viewModel.complaints.enumerated()), id: \.offset) { _, item in
                        ComplaintCardView(item: item) {
                            coordinator.showComplaintDetails(complaintId: item.id ?? 0)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            Spacer()
        }
        .safeAreaInset(edge: .bottom) {
            MainButton(title: "Create New Complaint".localized) {
                coordinator.showCreateComplaint()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .navigationTitle("Complaints and Suggestions".localized)
        .task {
            await viewModel.fetchComplaints()
        }
    }
}

