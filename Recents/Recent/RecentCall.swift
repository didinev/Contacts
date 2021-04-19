import Foundation

struct RecentCall: Equatable {
    var name: String
    var typeOfCall: String
    var date: Date
    
    var formattedDate : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.MM.yy"
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
    
    var isMissed: Bool
}
