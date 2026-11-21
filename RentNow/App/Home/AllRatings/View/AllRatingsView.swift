//
//  AllRatingsView.swift
//  RentNow
//

import SwiftUI

struct AllRatingsView: View {

    @ObservedObject var viewModel: AllRatingsViewModel

    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true) {
            if viewModel.ratings.isEmpty && !viewModel.isLoading {
                VStack {
                    Spacer()
                    Text("No ratings yet".localized)
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .foregroundColor(.black.opacity(0.6))
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 12) {
                        ForEach(Array(viewModel.ratings.enumerated()), id: \.offset) { _, rate in
                            RatingCardView(
                                image: rate.image ?? "",
                                name: rate.name ?? "",
                                date: rate.date,
                                rating: rate.rate ?? 0
                            )
                            .onAppear {
                                viewModel.loadMoreIfNeeded(currentItem: rate)
                            }
                        }

                        if viewModel.isLoadingMore {
                            ProgressView()
                                .padding()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
        }
        .navigationTitle("Ratings".localized)
        .task {
            await viewModel.fetchRatings()
        }
    }
}

#Preview {
    AllRatingsView(viewModel: AllRatingsViewModel(advertisementId: 1))
}
