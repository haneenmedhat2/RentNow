//
//  PersonalProfileView.swift
//  RentNow
//

import SwiftUI

struct PersonalProfileView: View {
    @ObservedObject var viewModel: PersonalProfileViewModel

    var body: some View {
        ZStack {
            MainGradientView()
                .ignoresSafeArea()

            BaseView(
                viewModel: viewModel,
                showMainBackground: false,
                disableScroll: false
            ) {
                VStack(spacing: 16) {
                    if let profile = viewModel.profile {
                        PersonalProfileCardView(profile: profile)
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
        }
        .navigationTitle("Personal Profile".localized)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.fetchProfile()
        }
    }
}
