//
//  CreateComplaintViewModel.swift
//  RentNow
//

import Foundation
import UIKit
import Combine

@MainActor
class CreateComplaintViewModel: BaseViewModel {

    // MARK: - Published Properties
    @Published var title: String = ""
    @Published var titleError: String? = nil
    @Published var message: String = ""
    @Published var messageError: String? = nil
    @Published var mediaItems: [MediaItem] = []
    @Published var mediaError: String? = nil

    // MARK: - Callbacks
    var onSuccess: (() -> Void)?

    // MARK: - API Calls
    func submitComplaint() {
        Task {
            // Validate title
            do {
                let _ = try GeneralValidationService.validate(title: title)
                titleError = nil
            } catch {
                titleError = error.localizedDescription
                return
            }

            // Validate message
            do {
                let _ = try GeneralValidationService.validate(message: message)
                messageError = nil
            } catch {
                messageError = error.localizedDescription
                return
            }

            // Prepare image upload
            var imageUpload: UploadData? = nil
            if let firstItem = mediaItems.first,
               let imageData = firstItem.image.jpegData(compressionQuality: 0.8) {
                imageUpload = UploadData(key: "Image", data: imageData, mimeType: .jpeg)
            }

            showIndicator()
            let endpoint = MoreEndpoint.createComplaint(
                title: title,
                message: message,
                image: imageUpload
            )
            do {
                let _ = try await request(endpoint)
                onSuccess?()
            } catch {
                showError(error.localizedDescription)
            }
            hideIndicator()
        }
    }
}
