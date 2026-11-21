//
//  CancellationTermsView.swift
//  RentNow
//

import SwiftUI

struct CancellationTermsView: View {
    @ObservedObject var viewModel: CancellationTermsViewModel

    var body: some View {
        ZStack {
            MainGradientView()
                .ignoresSafeArea()

            BaseView(viewModel: viewModel, showMainBackground: false) {
                ScrollView {
                    if viewModel.conditions.isEmpty && !viewModel.isLoading {
                        Text("There are no Cancellation and Delay Terms".localized)
                            .expoSystemFont(size: FontSize.normal, weight: .regular)
                            .foregroundColor(.gray)
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        Text(viewModel.conditions)
                            .expoSystemFont(size: FontSize.normal, weight: .regular)
                            .foregroundColor(.black)
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Cancellation and Delay Terms".localized)
        .task {
            await viewModel.fetchConditions()
        }
    }
}
