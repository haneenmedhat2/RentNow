//
//  NotificationModel.swift
//  RentNow
//
//  Created by Claude Code
//

import Foundation

// MARK: - NotificationItem Model
struct NotificationItem: Codable, Identifiable, Hashable {
    let id: Int
    let title: String?
    let message: String
    let date: String
    let type: Int?
    let itemId: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case message
        case date
        case type
        case itemId
    }

    // Computed property for time ago display
    var timeAgo: String {
        return date.toNotificationTimeAgo()
    }
}

// MARK: - String Extension for Date Parsing
extension String {
    /// Converts API date string to relative time string
    /// Format: "yyyy-MM-dd HH:mm:ss.SSSSSSS" → "5 minutes ago"
    func toNotificationTimeAgo() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSS"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = dateFormatter.date(from: self) else {
            // Fallback to shorter format if parsing fails
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            guard let fallbackDate = dateFormatter.date(from: self) else {
                return "notification_time_just_now".localized
            }
            return fallbackDate.toRelativeTime()
        }

        return date.toRelativeTime()
    }
}

// MARK: - Date Extension for Relative Time
extension Date {
    /// Converts Date to localized relative time string
    func toRelativeTime() -> String {
        let now = Date()
        let timeInterval = now.timeIntervalSince(self)

        // Less than 1 minute
        if timeInterval < 60 {
            return "notification_time_just_now".localized
        }

        // Minutes ago
        let minutes = Int(timeInterval / 60)
        if minutes < 60 {
            return String(format: "notification_time_minutes_ago".localized, minutes)
        }

        // Hours ago
        let hours = Int(timeInterval / 3600)
        if hours < 24 {
            return String(format: "notification_time_hours_ago".localized, hours)
        }

        // Days ago
        let days = Int(timeInterval / 86400)
        if days < 7 {
            return String(format: "notification_time_days_ago".localized, days)
        }

        // Weeks ago
        let weeks = Int(timeInterval / 604800)
        if weeks < 4 {
            return String(format: "notification_time_weeks_ago".localized, weeks)
        }

        // Months ago
        let months = Int(timeInterval / 2592000)
        return String(format: "notification_time_months_ago".localized, months)
    }
}
