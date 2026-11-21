//
//  InfoContentView.swift
//  RentNow
//

import SwiftUI

struct InfoContentView: View {

    @ObservedObject var viewModel: InfoContentViewModel

    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true) {
            if viewModel.isEmpty {
                VStack {
                    Spacer()
                    if !viewModel.type.emptyMessage.isEmpty {
                        Text(viewModel.type.emptyMessage)
                            .expoSystemFont(size: FontSize.normal, weight: .regular)
                            .foregroundColor(.black.opacity(0.6))
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                ScrollView(showsIndicators: false) {
                    Text(viewModel.content)
                        .expoSystemFont(size: FontSize.normal, weight: .regular)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                }
            }
        }
        .navigationTitle(viewModel.title)
        .task {
            await viewModel.fetchContent()
        }
    }
}

