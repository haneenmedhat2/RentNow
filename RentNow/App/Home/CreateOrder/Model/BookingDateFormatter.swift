import Foundation

enum BookingDateFormatter {
    static func dateTimes(from: String, to: String, time: String) -> (from: String, to: String)? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.isLenient = false

        let fromInput = "\(from)T\(time)"
        let toInput = "\(to)T\(time)"
        for timeFormat in ["hh:mm a", "HH:mm"] {
            formatter.dateFormat = "yyyy-MM-dd'T'\(timeFormat)"
            guard let start = formatter.date(from: fromInput), let end = formatter.date(from: toInput),
                  formatter.string(from: start) == fromInput, formatter.string(from: end) == toInput,
                  end >= start else { continue }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            return (formatter.string(from: start), formatter.string(from: end))
        }
        return nil
    }
}
