//
//  RangeSliderView.swift
//  RentNow
//

import SwiftUI

/// A generic dual-thumb range slider.
/// Pins layout to LTR so that `.leading` alignment and `.offset(x:)`
/// behave correctly regardless of the app's current language — the same
/// approach used by `ImageSliderView`.
struct RangeSliderView: View {

    @Binding var lowerValue: Double
    @Binding var upperValue: Double
    let range: ClosedRange<Double>
    var step: Double = 10   // minimum gap between lowerValue and upperValue

    var body: some View {
        GeometryReader { geometry in
            let thumbSize: CGFloat = 24
            let trackHeight: CGFloat = 6

            let totalWidth = max(geometry.size.width, 0)
            let usableTrackWidth = max(totalWidth - thumbSize, 0)

            let rawRange = range.upperBound - range.lowerBound
            let safeRange = (rawRange.isFinite && rawRange > 0) ? rawRange : 1

            let clampedLower = min(max(lowerValue, range.lowerBound), range.upperBound)
            let clampedUpper = min(max(upperValue, range.lowerBound), range.upperBound)

            let orderedLower = min(clampedLower, clampedUpper)
            let orderedUpper = max(clampedLower, clampedUpper)

            let lowerRatio = CGFloat((orderedLower - range.lowerBound) / safeRange)
            let upperRatio = CGFloat((orderedUpper - range.lowerBound) / safeRange)

            let lowerX = min(max(lowerRatio * usableTrackWidth, 0), usableTrackWidth)
            let upperX = min(max(upperRatio * usableTrackWidth, 0), usableTrackWidth)

            let selectedWidth = max(upperX - lowerX, 0)

            ZStack(alignment: .leading) {
                // Track background
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: trackHeight)
                    .offset(y: (thumbSize - trackHeight) / 2)

                // Selected range bar
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.mainColor)
                    .frame(width: selectedWidth, height: trackHeight)
                    .offset(x: lowerX + thumbSize / 2, y: (thumbSize - trackHeight) / 2)

                // Lower thumb
                Circle()
                    .fill(Color.white)
                    .frame(width: thumbSize, height: thumbSize)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                    .overlay(
                        Circle()
                            .fill(Color.mainColor)
                            .frame(width: 12, height: 12)
                    )
                    .position(x: lowerX + thumbSize / 2, y: thumbSize / 2)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let localX = min(max(value.location.x - thumbSize / 2, 0), usableTrackWidth)
                                let newValue = range.lowerBound + Double(localX / usableTrackWidth) * safeRange
                                let bounded = min(newValue, orderedUpper - step)
                                let final = max(range.lowerBound, bounded)
                                if final.isFinite {
                                    lowerValue = final
                                }
                            }
                    )

                // Upper thumb
                Circle()
                    .fill(Color.white)
                    .frame(width: thumbSize, height: thumbSize)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                    .overlay(
                        Circle()
                            .fill(Color.mainColor)
                            .frame(width: 12, height: 12)
                    )
                    .position(x: upperX + thumbSize / 2, y: thumbSize / 2)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let localX = min(max(value.location.x - thumbSize / 2, 0), usableTrackWidth)
                                let newValue = range.lowerBound + Double(localX / usableTrackWidth) * safeRange
                                let bounded = max(newValue, orderedLower + step)
                                let final = min(range.upperBound, bounded)
                                if final.isFinite {
                                    upperValue = final
                                }
                            }
                    )
            }
            // RTL fix: force LTR so .leading alignment and .offset(x:) work
            // correctly in Arabic — same pattern used by ImageSliderView.
            .environment(\.layoutDirection, .leftToRight)
        }
        .frame(height: 24)
    }
}

#Preview {
    RangeSliderView(
        lowerValue: .constant(100),
        upperValue: .constant(500),
        range: 0...1000
    )
    .padding()
}
