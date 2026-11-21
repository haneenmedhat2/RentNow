//
//  MediaItem.swift
//  Holool
//
//  Created by Elshamy on 02/12/2025.
//

import UIKit
import Foundation



enum MediaType {
    case photoOnly
    case videoOnly
    case photoAndVideo
}


struct MediaItem: Identifiable , Equatable {
    let id = UUID()
    let image: UIImage
    let type: MediaType
    let videoURL: URL?
    
    enum MediaType {
        case photo
        case video
    }
    
    init(image: UIImage) {
        self.image = image
        self.type = .photo
        self.videoURL = nil
    }
    
    init(videoURL: URL, thumbnail: UIImage) {
        self.image = thumbnail
        self.type = .video
        self.videoURL = videoURL
    }
}
