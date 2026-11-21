import SwiftUI

struct EmptyPlaceholderView: View {
    let message: String
    var height: CGFloat = 400
    var font: Font = .system(size: 14)
    var color: Color = .gray

    var body: some View {
        Text(message)
            .font(font)
            .foregroundColor(color)
            .frame(height: height)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .accessibilityLabel(message)
    }
}

#Preview {
    EmptyPlaceholderView(message: "No data available")
}
