//
//  AdvertisementDetailsImageSliderView.swift
//  RentNow
//

import SwiftUI
import UIKit

struct AdvertisementDetailsImageSliderView: View {

    // MARK: - Properties

    let images: [ImageData]
    let onBack: () -> Void

    // MARK: - State

    @State private var currentIndex: Int = 0
    @State private var tabViewID = UUID()

    // MARK: - Configuration

    private enum Config {
        static let height: CGFloat = 300
        static let indicatorSpacing: CGFloat = 8
        static let backButtonSize: CGFloat = 36
        static let backButtonPadding: CGFloat = 8
        static let indicatorBottomPadding: CGFloat = 20
    }

    // MARK: - Computed Properties

    private var topSafeAreaInset: CGFloat {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0 }
        return scene.windows.first?.safeAreaInsets.top ?? 0
    }

    private var isRTL: Bool {
        Language.isRTL()
    }

    private var displayImages: [ImageData] {
        isRTL ? images.reversed() : images
    }

    private var hasMultipleImages: Bool {
        images.count > 1
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Layer 1: paging TabView (full bleed)
                TabView(selection: $currentIndex) {
                    ForEach(displayImages.indices, id: \.self) { index in
                        RemoteImageView(url: displayImages[index].image)
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .environment(\.layoutDirection, .leftToRight)
                .id(tabViewID)
                .onAppear(perform: handleAppear)

                // Layer 2: back button (top, leading)
                VStack {
                    HStack {
                        backButton
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, topSafeAreaInset + Config.backButtonPadding)
                    Spacer()
                }

                // Layer 3: page indicators (bottom center)
                if hasMultipleImages {
                    VStack {
                        Spacer()
                        pageIndicatorRow
                            .padding(.bottom, Config.indicatorBottomPadding)
                    }
                }
            }
        }
        .frame(height: Config.height)
    }

    // MARK: - Back Button

    private var backButton: some View {
        Button(action: onBack) {
            Image("detailsBackButton")
                .resizable()
                .scaledToFit()
                .frame(width: 40 , height:40)
        }
    }

    // MARK: - Page Indicators

    private var pageIndicatorRow: some View {
        HStack(spacing: Config.indicatorSpacing) {
            ForEach(images.indices, id: \.self) { index in
                indicatorDot(for: index)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: currentIndex)
    }

    private func indicatorDot(for index: Int) -> some View {
        let displayIdx = displayIndex(from: index)
        let isSelected = currentIndex == displayIdx

        return Group {
            if isSelected {
                Capsule().frame(width: 20, height: 8)
            } else {
                Circle().frame(width: 8, height: 8)
            }
        }
        .foregroundColor(isSelected ? .white : .white.opacity(0.4))
    }

    // MARK: - Index Conversion

    private func displayIndex(from actualIndex: Int) -> Int {
        isRTL ? (images.count - 1 - actualIndex) : actualIndex
    }

    // MARK: - Actions

    private func handleAppear() {
        if isRTL {
            currentIndex = images.count - 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            tabViewID = UUID()
        }
    }
}
