//
//  IntroView.swift
//  RentNow
//
//  Created by Claude on 22/01/2026.
//

import SwiftUI

struct IntroView: View {

    @StateObject private var viewModel = IntroViewModel()
    var onFinish: (() -> Void)?

    var body: some View {
        ZStack {
            // Show content only when data is loaded
            if viewModel.isDataLoaded && !viewModel.splashScreens.isEmpty {
                // Background Image with TabView for swiping
                TabView(selection: $viewModel.currentPageIndex) {
                    ForEach(Array(viewModel.splashScreens.enumerated()), id: \.element.id) { index, splashScreen in
                        IntroPageView(splashScreen: splashScreen)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea()

                // Header: Skip + Logo
                IntroHeaderView(
                    onSkip: {
                        onFinish?()
                    }
                )

                // Bottom Navigation
                IntroNavigationView(
                    currentIndex: viewModel.currentPageIndex,
                    totalPages: viewModel.totalPages,
                    isLastPage: viewModel.isLastPage,
                    onPrevious: { viewModel.previousPage() },
                    onNext: { viewModel.nextPage() },
                    onStart: {
                        onFinish?()
                    }
                )
            } else if viewModel.isLoading {
                // Loading state
                Color(.main)
                    .ignoresSafeArea()
                    .overlay(
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(1.5)
                    )
            } else {
                // Error or empty state - skip to login
                Color(.main)
                    .ignoresSafeArea()
                    .onAppear {
                        // If no splash screens or error, skip intro
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            onFinish?()
                        }
                    }
            }
        }
        .ignoresSafeArea()
        .logViewAppearance()
    }
}

#Preview {
    IntroView()
}
