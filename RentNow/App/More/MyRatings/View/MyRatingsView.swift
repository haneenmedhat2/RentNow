//
//  MyRatingsView.swift
//  RentNow
//

import SwiftUI

struct MyRatingsView: View {

    @ObservedObject var viewModel: MyRatingsViewModel

    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true) {
            if viewModel.isEmpty {
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
                    LazyVStack(spacing: 16) {
                        ForEach(Array(viewModel.ratings.enumerated()), id: \.offset) { _, item in
                            MyRatingItemCardView(item: item)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
            }
        }
        .navigationTitle("My Ratings".localized)
        .task {
            await viewModel.fetchRatings()
        }
    }
}

#Preview {
    MyRatingsView(viewModel: MyRatingsViewModel())
}
