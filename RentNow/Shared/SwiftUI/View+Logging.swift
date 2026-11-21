import SwiftUI

extension View {
    /// Logs the view's name when it enters the visible hierarchy.
    func logViewAppearance(viewName: String? = nil, fileID: String = #fileID) -> some View {
        #if DEBUG
        onAppear {
            let name = viewName ?? URL(fileURLWithPath: fileID).deletingPathExtension().lastPathComponent
            print("[View] \(name)")
        }
        #else
        self
        #endif
    }
}
