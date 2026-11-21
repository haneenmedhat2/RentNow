// BaseCoordinator.swift
// Holool
// Created by Elshamy on 21/10/2025.

import SwiftUI
import Combine

// MARK: - Coordinator Protocol
protocol Coordinator: AnyObject {
    associatedtype Route: Hashable
    var path: [Route] { get set }
    var onFinish: (() -> Void)? { get set }
}

// MARK: - Base Coordinator
/// BaseCoordinator manages common navigation helpers + child coordinators lifecycle using SwiftUI NavigationStack
@MainActor
class BaseCoordinator<Route: Hashable>: ObservableObject, Coordinator {

    @Published var path: [Route] = []
    var onFinish: (() -> Void)?

    // Sheet presentation
    @Published var sheetContent: AnyView?
    @Published var isSheetPresented: Bool = false
    @Published var sheetDetents: Set<PresentationDetent> = [.height(500)]
    @Published var sheetDragIndicator: Visibility = .visible
    private var sheetDismissalAction: (() -> Void)?

    // Fullscreen cover presentation
    @Published var fullScreenContent: AnyView?
    @Published var isFullScreenPresented: Bool = false

    // Content that runs over the current screen without presenting another page.
    @Published var overlayContent: AnyView?

    // Popup overlay presentation
    @Published var popupContent: AnyView?
    @Published var isPopupPresented: Bool = false

    /// Central storage of child coordinators
    private(set) var childCoordinators: [AnyObject] = []

    init() {}

    // MARK: - Navigation Methods

    func push(_ route: Route) {
        path.append(route)
    }

    @discardableResult
    func pop() -> Route? {
        path.popLast()
    }

    func popToRoot() {
        path.removeAll()
    }

    func replace(with route: Route) {
        path = [route]
    }

    func reset() {
        path.removeAll()
    }

    var bindingPath: Binding<[Route]> {
        Binding(
            get: { self.path },
            set: { self.path = $0 }
        )
    }

    // MARK: - Child Management

    func addChild<T: AnyObject>(_ coordinator: T) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }

    func removeChild<T: AnyObject>(_ coordinator: T) {
        childCoordinators.removeAll { $0 === coordinator }
    }

    func removeAllChildren() {
        childCoordinators.removeAll()
    }

    // MARK: - Presentation Methods

    /// Present as bottom sheet
    func presentAsSheet<Content: View>(
        _ view: Content,
        detentHeight: CGFloat = 500,
        detents: Set<PresentationDetent>? = nil,
        showsDragIndicator: Bool = true
    ) {
        sheetDetents = detents ?? [.height(detentHeight)]
        sheetDragIndicator = showsDragIndicator ? .visible : .hidden
        sheetContent = AnyView(view)
        isSheetPresented = true
    }

    /// Start the next flow after SwiftUI has actually dismissed the current sheet.
    func dismissSheet(then action: @escaping () -> Void) {
        guard isSheetPresented else {
            action()
            return
        }
        sheetDismissalAction = action
        dismiss()
    }

    fileprivate func sheetDidDismiss() {
        let action = sheetDismissalAction
        sheetDismissalAction = nil
        action?()
    }

    /// Present fullscreen
    func presentFullScreen<Content: View>(_ view: Content) {
        fullScreenContent = AnyView(view)
        isFullScreenPresented = true
    }

    func presentOverlay<Content: View>(_ view: Content) {
        overlayContent = AnyView(view)
    }

    /// Present as popup overlay
    func presentAsPopup<Content: View>(_ view: Content) {
        popupContent = AnyView(view)
        isPopupPresented = true
    }

    /// Dismiss any presented content
    func dismiss() {
        isSheetPresented = false
        isFullScreenPresented = false
        isPopupPresented = false
        sheetContent = nil
        fullScreenContent = nil
        popupContent = nil
        overlayContent = nil
    }

    /// Close current screen (pop if in stack, dismiss if presented)
    func close() {
        if !path.isEmpty {
            pop()
        } else {
            dismiss()
        }
    }
}

// MARK: - Presentation Modifiers

struct CoordinatorPresentationModifier<Route: Hashable>: ViewModifier {
    @ObservedObject var coordinator: BaseCoordinator<Route>

    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $coordinator.isSheetPresented, onDismiss: {
                coordinator.sheetDidDismiss()
            }) {
                if let sheetContent = coordinator.sheetContent {
                    sheetContent
                        .presentationDetents(coordinator.sheetDetents)
                        .presentationDragIndicator(coordinator.sheetDragIndicator)
                }
            }
            .fullScreenCover(isPresented: $coordinator.isFullScreenPresented) {
                if let fullScreenContent = coordinator.fullScreenContent {
                    fullScreenContent
                }
            }
            .overlay {
              if coordinator.isPopupPresented, let popupContent = coordinator.popupContent {
                ZStack {
                  Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture { coordinator.dismiss() }

                  popupContent
                    .transition(.opacity.combined(with: .scale))
                }
              }
            }
            .animation(.easeInOut(duration: 0.3), value: coordinator.isPopupPresented)
            .overlay {
                if let overlayContent = coordinator.overlayContent {
                    overlayContent
                }
            }
    }
}

extension View {
    func withCoordinatorPresentation<Route: Hashable>(_ coordinator: BaseCoordinator<Route>) -> some View {
        modifier(CoordinatorPresentationModifier(coordinator: coordinator))
    }
}

