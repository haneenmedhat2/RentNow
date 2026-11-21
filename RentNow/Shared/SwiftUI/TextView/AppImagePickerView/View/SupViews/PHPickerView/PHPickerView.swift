//
//  PHPickerMediaView.swift
//  Holool
//
//  Created by Elshamy on 02/12/2025.
//

import SwiftUI
import PhotosUI
import AVFoundation

struct PHPickerMediaView: UIViewControllerRepresentable {
    let mediaType: MediaType
    let maxSelection: Int
    @Binding var mediaItems: [MediaItem]
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        
        // ✅ تحديد نوع الميديا
        switch mediaType {
        case .photoOnly:
            config.filter = .images
        case .videoOnly:
            config.filter = .videos
        case .photoAndVideo:
            config.filter = .any(of: [.images, .videos])
        }
        
        config.selectionLimit = maxSelection
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PHPickerMediaView
        
        init(_ parent: PHPickerMediaView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.dismiss()
            
            for result in results {
                // ✅ تحميل الصور
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                let mediaItem = MediaItem(image: image)
                                self.parent.mediaItems.append(mediaItem)
                            }
                        }
                    }
                }
                
                // ✅ تحميل الفيديوهات
                if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                    result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { url, error in
                        if let url = url {
                            // حفظ الفيديو في temporary directory
                            let documentsDirectory = FileManager.default.temporaryDirectory
                            let fileName = UUID().uuidString + ".mov"
                            let newURL = documentsDirectory.appendingPathComponent(fileName)
                            
                            do {
                                // نسخ الفيديو
                                if FileManager.default.fileExists(atPath: newURL.path) {
                                    try FileManager.default.removeItem(at: newURL)
                                }
                                try FileManager.default.copyItem(at: url, to: newURL)
                                
                                // ✅ Generate thumbnail
                                if let thumbnail = self.generateThumbnail(for: newURL) {
                                    DispatchQueue.main.async {
                                        let mediaItem = MediaItem(videoURL: newURL, thumbnail: thumbnail)
                                        self.parent.mediaItems.append(mediaItem)
                                    }
                                }
                            } catch {
                                print("❌ Error copying video: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
        }
        
        // ✅ Generate thumbnail للفيديو
        private func generateThumbnail(for url: URL) -> UIImage? {
            let asset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            
            // للحصول على صورة أفضل
            imageGenerator.maximumSize = CGSize(width: 300, height: 300)
            
            do {
                let cgImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
                return UIImage(cgImage: cgImage)
            } catch {
                print("❌ Error generating thumbnail: \(error.localizedDescription)")
                return nil
            }
        }
    }
}
