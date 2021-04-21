import Foundation

struct Call: Equatable, Codable {
    var name: String
    var typeOfCall: String
    var date: Date
    var isMissed: Bool
    var isOutgoing: Bool
    
    static let todayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    static let lastWeekDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    static let moreThanWeekDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.MM.yy"
        return formatter
    }()

    let weekDuration = TimeInterval(60 * 60 * 24 * 7)
    
    var formattedDate: String {
        if Calendar.current.isDateInToday(date) {
            return Call.todayDateFormatter.string(from: date)
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else if date.distance(to: Date()) < weekDuration {
            return Call.lastWeekDateFormatter.string(from: date)
        } else {
            return Call.moreThanWeekDateFormatter.string(from: date)
        }
    }
}
