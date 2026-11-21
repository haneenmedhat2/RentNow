//
//  NativeCameraMediaView.swift
//  Holool
//
//  Created by Elshamy on 02/12/2025.
//

import SwiftUI
import UIKit
import AVFoundation

struct NativeCameraMediaView: UIViewControllerRepresentable {
    let mediaType: MediaType
    @Binding var mediaItems: [MediaItem]
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        picker.showsCameraControls = true
        
        // Set media types based on mediaType
        switch mediaType {
        case .photoOnly:
            picker.mediaTypes = ["public.image"]
            picker.cameraCaptureMode = .photo
            
        case .videoOnly:
            picker.mediaTypes = ["public.movie"]
            picker.cameraCaptureMode = .video
            picker.videoQuality = .typeHigh
            picker.videoMaximumDuration = 60
            
        case .photoAndVideo:
            picker.mediaTypes = ["public.image", "public.movie"]
            picker.cameraCaptureMode = .photo
            picker.videoQuality = .typeHigh
            picker.videoMaximumDuration = 60
        }
        
        // ✅ Make it fullscreen
        picker.modalPresentationStyle = .fullScreen
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: NativeCameraMediaView
        
        init(_ parent: NativeCameraMediaView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            // Image
            if let image = info[.originalImage] as? UIImage {
                let mediaItem = MediaItem(image: image)
                parent.mediaItems.append(mediaItem)
                parent.dismiss()
                return
            }
            
            // Video
            if let videoURL = info[.mediaURL] as? URL {
                if let thumbnail = generateThumbnail(for: videoURL) {
                    let mediaItem = MediaItem(videoURL: videoURL, thumbnail: thumbnail)
                    parent.mediaItems.append(mediaItem)
                } else {
                    if let placeholderImage = createPlaceholderImage() {
                        let mediaItem = MediaItem(videoURL: videoURL, thumbnail: placeholderImage)
                        parent.mediaItems.append(mediaItem)
                    }
                }
                parent.dismiss()
                return
            }
            
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
        
        private func generateThumbnail(for url: URL) -> UIImage? {
            let asset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            imageGenerator.maximumSize = CGSize(width: 300, height: 300)
            
            do {
                let cgImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
                return UIImage(cgImage: cgImage)
            } catch {
                print("❌ Error generating thumbnail: \(error.localizedDescription)")
                return nil
            }
        }
        
        private func createPlaceholderImage() -> UIImage? {
            let size = CGSize(width: 100, height: 100)
            let renderer = UIGraphicsImageRenderer(size: size)
            
            return renderer.image { context in
                UIColor.black.withAlphaComponent(0.3).setFill()
                context.fill(CGRect(origin: .zero, size: size))
                
                let path = UIBezierPath()
                path.move(to: CGPoint(x: 35, y: 25))
                path.addLine(to: CGPoint(x: 35, y: 75))
                path.addLine(to: CGPoint(x: 70, y: 50))
                path.close()
                
                UIColor.white.setFill()
                path.fill()
            }
        }
    }
}
