import SwiftUI
import Combine

// 1️⃣ ToastManager singleton
final class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var message: String = ""
    @Published var type: ToastType = .success
    @Published var isShowing: Bool = false
    
    private init() {}
    
    func show(message: String, type: ToastType = .success, duration: Double = 2.0) {
        self.message = message
        self.type = type
        withAnimation {
            self.isShowing = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation {
                self.isShowing = false
            }
        }
    }
}

// 2️⃣ ViewModifier عام
struct GlobalToastPresenter: ViewModifier {
    @ObservedObject var manager = ToastManager.shared
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if manager.isShowing {
                VStack {
                    ToastView(message: manager.message, type: manager.type)
                    Spacer()
                }.padding(.top, 0)
                .transition(.move(edge: .top).combined(with: .opacity))
                .zIndex(1)
            }
        }
    }
}

extension View {
    // ✅ فقط سطر واحد
    func withGlobalToast() -> some View {
        self.modifier(GlobalToastPresenter())
    }
}
