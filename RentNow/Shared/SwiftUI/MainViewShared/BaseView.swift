//
//  BaseView.swift
//  Holool
//
//  Created by Elshamy on 03/11/2025.
//

import SwiftUI
import UIKit

struct BaseView<Content: View>: View {
    @ObservedObject var viewModel: BaseViewModel
    let content: Content
    var showMainBackground: Bool = true
    var disableScroll: Bool = false
    var emptyStateMessage: String? = nil
    private let sourceFileID: String

    @Environment(\.dismiss) private var dismiss
    @State private var hideToastWorkItem: DispatchWorkItem?
    @State private var contentHeight: CGFloat = 0

    init(
        viewModel: BaseViewModel,
        showMainBackground: Bool = true,
        disableScroll: Bool = false,
        emptyStateMessage: String? = nil,
        fileID: String = #fileID,
        @ViewBuilder content: () -> Content
    ) {
        self.viewModel = viewModel
        self.showMainBackground = showMainBackground
        self.disableScroll = disableScroll
        self.emptyStateMessage = emptyStateMessage
        self.sourceFileID = fileID
        self.content = content()
    }

    var body: some View {
        ZStack {
            if showMainBackground == true {
                MainGradientView()
                    .ignoresSafeArea()
            }

            VStack(spacing: 0) {
                Color.clear.frame(height: 8)

                if let emptyMessage = emptyStateMessage {
                    // Show empty state
                    GeometryReader { geo in
                        VStack {
                            Spacer()
                            EmptyPlaceholderView(
                                message: emptyMessage,
                                height: geo.size.height * 0.4,
                                font: .system(size: 16),
                                color: Color(hex: "8A8A8A")
                            )
                            Spacer()
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                    }

                } else if disableScroll {
                    GeometryReader { geo in
                        ScrollView(showsIndicators: false) {
                            content
                                .frame(width: geo.size.width) // ✅ prevent horizontal overflow
                                .disabled(viewModel.isLoading)
                                .blur(radius: viewModel.isLoading ? 2 : 0)
                        }
                    }

                } else {
                    GeometryReader { geo in
                        ScrollView(showsIndicators: false) {
                            content
                                .frame(width: geo.size.width) // ✅ prevent horizontal overflow
                                .frame(minHeight: geo.size.height)
                                .background(
                                    GeometryReader { contentGeo in
                                        Color.clear.preference(
                                            key: ContentHeightKey.self,
                                            value: contentGeo.size.height
                                        )
                                    }
                                )
                        }
                        .onPreferenceChange(ContentHeightKey.self) { height in
                            contentHeight = height
                        }
                        .scrollDisabled(contentHeight <= geo.size.height)
                        .disabled(viewModel.isLoading)
                        .blur(radius: viewModel.isLoading ? 2 : 0)
                    }
                }
            }

            if viewModel.isLoading {
                LoaderUIView()
            }

            if let toastData = viewModel.toast {
                VStack {
                    ToastView(message: toastData.message, type: toastData.type)
                        .padding(.top, 50)
                        .onAppear {
                            hideToastWorkItem?.cancel()
                            let workItem = DispatchWorkItem {
                                withAnimation(.easeInOut) {
                                    viewModel.toast = nil
                                }
                            }
                            hideToastWorkItem = workItem
                            DispatchQueue.main.asyncAfter(deadline: .now() + toastData.duration, execute: workItem)
                        }
                    Spacer()
                }
                .zIndex(1)
            }
        }
        .contentShape(Rectangle())
        .logViewAppearance(fileID: sourceFileID)
        .simultaneousGesture(
            TapGesture().onEnded {
                hideKeyboard()
            }
        )
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
