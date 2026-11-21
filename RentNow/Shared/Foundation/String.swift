//
//  String.swift
//  App
//
//  Created by MGAbouarab on 08/01/2024.
//

import Foundation

extension String {
    func trimWhiteSpace() -> String{
        let newValue = self.trimmingCharacters(in: .whitespacesAndNewlines)
        return newValue
    }
    func isValidEmail() -> Bool {
        let testEmail = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
        return testEmail.evaluate(with: self)
    }
    func isValidPhoneNumber(pattern: String) -> Bool {
        return self.range(of: pattern ,options: .regularExpression) != nil
    }
}

//
//  String.swift
//
//  Created by MGAbouarab®
//

import Foundation
import UIKit

// MARK: - Validate


// MARK: - Converters -
extension String {
    
    var replacedArabicDigitsWithEnglish: String {
        var str = self
        let map = [
            "٠": "0",
            "١": "1",
            "٢": "2",
            "٣": "3",
            "٤": "4",
            "٥": "5",
            "٦": "6",
            "٧": "7",
            "٨": "8",
            "٩": "9",
        ]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
    var replacedEnglishDigitsWithArabic: String {
        var str = self
        let map = ["٠": "0",
                   "١": "1",
                   "٢": "2",
                   "٣": "3",
                   "٤": "4",
                   "٥": "5",
                   "٦": "6",
                   "٧": "7",
                   "٨": "8",
                   "٩": "9"]
        map.forEach { str = str.replacingOccurrences(of: $1, with: $0) }
        return str
    }
    var isInt: Bool {
        return Int(self) != nil
    }
    var isDouble: Bool {
        return Double(self) != nil
    }
    
    func toDouble() -> Double {
        return Double(self) ?? 0.0
    }
    func toInt() -> Int {
        return Int(self) ?? 0
    }
    func toPrice() -> String {
        return String(format: "%.01f", self.toDouble()) + " " + appCurrency
    }
//    func toKiloMeter() -> String {
//        return String(format: "%.01f", self.toDouble()) + " " + appDistance
//    }
    func increase() -> String {
        return String(self.toInt() + 1)
    }
    func decrease() -> String {
        guard self.toInt() > 1 else {return self}
        return String(self.toInt() - 1)
    }

    func toDate(formate: String = "dd-MM-yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = formate
        let date = dateFormatter.date(from: self)
        return date
    }
    func toTimeDate(formate: String = "HH:mm") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = formate
        let date = dateFormatter.date(from: self)
        return date
    }
    func toSpicalDate(format: String = "yyyy-MM-dd") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }

    func toDay() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        return date
    }
    func toTime() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: self)
        return date
    }
    @available(iOS 13.0, *)
    func toTimeAgo() -> String {
        guard let date = self.toDate() else {return String()}
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
}

// MARK: - NSAttributedString -



extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension String {
 
    var TheremeningTime: String? {
        // if you want time in one label
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let today = Date()
        guard let endTime = dateFormatter.date(from: self) else {return nil}
        return (endTime.timeIntervalSinceNow - today.timeIntervalSinceNow).toString()
    }
    
    // if you want time in more than label
    func remainingPeriods() -> (seconds: String, minutes: String, hours: String, days: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let today = Date()
        guard let endTime = dateFormatter.date(from: self) else {return ("00", "00","00","00")}
        return (endTime.timeIntervalSinceNow - today.timeIntervalSinceNow).toTheString()
    }
    
}
extension TimeInterval{
    
     // if you want time in one label
    func toString() -> String {
        
        let time = NSInteger(self)
        
        if time <= 0 {
            return "Expired".localized
           
        }
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600) % 24
        let days = (time / (3600*24))
        
        return String(format: "%0.2d" + "d".localized + " " + ":" + "%0.2d" + "h".localized + " " + ":" + "%0.2d" + "m".localized + " " + ":" + "%0.2d" + "s".localized,days,hours,minutes,seconds)
        
    }
    // if you want time in more than label
    func toTheString() -> (seconds: String, minutes: String, hours: String, days: String) {
        
        let time = NSInteger(self)
        
        if time <= 0 {
            return ("00", "00","00","00")
        }
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600) % 24
        let days = (time / (3600*24))
        
        return (
            String(format: "%0.2d \n" + "second".localized,seconds),
            String(format: "%0.2d \n" + "minute".localized,minutes),
            String(format: "%0.2d \n" + "hour".localized,hours),
            String(format: "%0.2d \n" + "day".localized,days)
        )
        
    }
}

extension String {
    // Change specific words color in whole text
    func change(strings: [String], with color: UIColor, characterSpacing: UInt? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        for string in strings {
            let range = (self as NSString).range(of: string)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        guard let characterSpacing = characterSpacing else {return attributedString}
        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSRange(location: 0, length: attributedString.length))
        
        return attributedString
    }
    
    
}

extension Date {
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
extension Date {
    func toTimeString(format: String = "HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
