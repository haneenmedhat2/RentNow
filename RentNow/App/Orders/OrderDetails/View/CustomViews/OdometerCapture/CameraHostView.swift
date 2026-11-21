//
//  CameraHostView.swift
//  RentNow
//

import SwiftUI
import Vision

struct CameraHostView: View {
    var onResult: (Data, Double) -> Void
    var onCancel: () -> Void

    @State private var mediaItems: [MediaItem] = []

    var body: some View {
        ZStack {
            NativeCameraMediaView(mediaType: .photoOnly, mediaItems: $mediaItems)
                .ignoresSafeArea()

            VStack {
                HStack {
                    Button {
                        onCancel()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding(.leading, 16)
                    .padding(.top, 8)

                    Spacer()
                }

                Spacer()

                Text("Odometer Photo".localized)
                    .expoSystemFont(size: FontSize.large, weight: .medium)
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(8)
                    .padding(.bottom, 120)
            }
        }
        .onChange(of: mediaItems) { items in
            if let item = items.last {
                processImage(image: item.image)
            }
        }
    }

    private func processImage(image: UIImage) {
        guard let photoData = image.jpegData(compressionQuality: 0.7),
              let cgImage = image.cgImage else { return }

        Task.detached {
            let reading = Self.extractOdometerReading(from: cgImage)
            await MainActor.run {
                onResult(photoData, reading)
            }
        }
    }

    private static func extractOdometerReading(from cgImage: CGImage) -> Double {
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = false

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])

        guard let observations = request.results else {
            return 0.0
        }

        var longestDigitSequence = ""

        for observation in observations {
            guard let candidate = observation.topCandidates(1).first else { continue }
            let text = candidate.string
            let digits = text.components(separatedBy: CharacterSet.decimalDigits.inverted)
            for seq in digits where seq.count > longestDigitSequence.count {
                longestDigitSequence = seq
            }
        }

        return Double(longestDigitSequence) ?? 0.0
    }
}
