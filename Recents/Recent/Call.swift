import Foundation

struct Call: Equatable {
    var name: String
    var typeOfCall: String
    var date: Date
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.MM.yy"
        formatter.locale = Locale.current
        return formatter
    }()
    
    var formattedDate : String {
        return Call.formatter.string(from: date)
    }
    
    var isMissed: Bool
}
