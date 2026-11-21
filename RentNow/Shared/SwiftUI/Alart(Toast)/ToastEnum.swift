//
//  ToastEnum.swift
//  Holool
//
//  Created by Elshamy on 03/11/2025.
//

import Foundation
import SwiftUI

enum ToastType {
    case success
    case error
    case warning
    case info
    
    var background: LinearGradient {
        switch self {
        case .success:
            return LinearGradient(colors: [.green.opacity(0.95), .green.opacity(0.75)], startPoint: .leading, endPoint: .trailing)
        case .error:
            return LinearGradient(colors: [.red.opacity(0.95), .red.opacity(0.75)], startPoint: .leading, endPoint: .trailing)
        case .warning:
            return LinearGradient(colors: [.orange.opacity(0.95), .orange.opacity(0.75)], startPoint: .leading, endPoint: .trailing)
        case .info:
            return LinearGradient(colors: [.blue.opacity(0.95), .blue.opacity(0.75)], startPoint: .leading, endPoint: .trailing)
        }
    }
    
    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.octagon.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }
    
    var hapticType: UINotificationFeedbackGenerator.FeedbackType {
        switch self {
        case .success: return .success
        case .error: return .error
        case .warning: return .warning
        case .info: return .success
        }
    }
}
