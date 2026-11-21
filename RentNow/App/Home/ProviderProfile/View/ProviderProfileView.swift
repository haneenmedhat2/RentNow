//
//  ProviderProfileView.swift
//  RentNow
//

import SwiftUI

struct ProviderProfileView: View {

    let coordinator: HomeCoordinatorProtocol
    @ObservedObject var viewModel: ProviderProfileViewModel

    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true) {
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        profileSection
                        adsSectionTitle
                        adsGrid
                    }
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("provider_profile.title".localized)
        .task {
            await viewModel.fetchProviderAds()
        }
    }

    // MARK: - Profile Section

    private var profileSection: some View {
        VStack(spacing: 12) {
            RemoteImageView(url: viewModel.providerImage.isEmpty ? nil : viewModel.providerImage)
                .frame(width: 100, height: 100)
                .clipShape(Circle())

            Text(viewModel.providerName)
                .expoSystemFont(size: FontSize.large, weight: .bold)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 16)
    }

    // MARK: - Ads Section Title

    private var adsSectionTitle: some View {
        Text("provider_profile.ads_section".localized)
            .expoSystemFont(size: FontSize.normal, weight: .bold)
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
    }

    // MARK: - Ads Grid

    private var adsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0)
        ], spacing: 4) {
            ForEach(viewModel.advertisements) { ad in
                MainCategoryDetailsCarCardView(advertisement: ad)
                    .padding(6)
                    .onTapGesture {
                        coordinator.showCarDetails(carId: ad.id)
                    }
            }
            if viewModel.advertisements.count % 2 != 0 {
                Color.clear
            }
        }
        .padding(.horizontal, 16)
    }
}
