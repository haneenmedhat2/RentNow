//
//  HomeView.swift
//  RentNow
//
//  Created by Elshamy on 25/01/2026.
//

import SwiftUI
import UIKit

struct HomeView: View {
    let coordinator: HomeCoordinatorProtocol
    @ObservedObject var viewModel: HomeViewModel

    @State private var currentBannerIndex = 0

    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true) {
            VStack(spacing: 0) {
                // Top Header with Logo and Location
                HomeTopHeaderView(
                    userAddress: viewModel.userAddress,
                    isVisitor: UserDefaults.isVisitor,
                    onLocationTap: {
                        viewModel.getCurrentLocation { latitude, longitude in
                            coordinator.showAirportsSheet(
                                latitude: latitude,
                                longitude: longitude
                            )
                        }
                    }
                )
                .padding(.horizontal, 16)
                .padding(.top, 8)

                // User Welcome Section
                HomeWelcomeSectionView(
                    userName: viewModel.userName,
                    userImage: viewModel.userImage,
                    userImageUrl: viewModel.userInfo?.imageUrl ?? viewModel.userImageUrl,
                    onSearchTap: {
                        coordinator.showSearch()
                    },
                    onNotificationTap: {
                        coordinator.showNotifications()
                    }
                )
                .padding(.horizontal, 16)
                .padding(.top, 16)

                // Banner Slider
                if !viewModel.sliders.isEmpty {
                    ImageSliderView(
                        images: viewModel.sliders,
                        height: 180
                    )
                    .padding(.top, 20)
                }

                // Categories Section
                HomeCategoriesSectionView(
                    categories: viewModel.categories,
                    onCategoryTap: { categoryId, categoryName in
                        coordinator.showCategoryList(categoryId: categoryId, categoryName: categoryName)
                    }
                )
                .padding(.horizontal, 16)
                .padding(.top, 24)

                Spacer()
            }
        }
        .navigationBarHidden(true)
        .task {
            await viewModel.fetchHomeData()
        }
    }
}

// MARK: - Category Item Model
struct CategoryItem: Identifiable {
    let id: Int
    let name: String
    let image: UIImage?
    let imageUrl: String?

    static var placeholder: [CategoryItem] {
        [
            CategoryItem(id: 1, name: "سيارات البر والتخييم", image: nil, imageUrl: nil),
            CategoryItem(id: 2, name: "سيارات صغيرة", image: nil, imageUrl: nil),
            CategoryItem(id: 3, name: "سيارات اقتصادية", image: nil, imageUrl: nil),
            CategoryItem(id: 4, name: "سيارات فخمة", image: nil, imageUrl: nil)
        ]
    }
}
