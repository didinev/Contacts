import Foundation

struct Call: Equatable, Codable {
    var name: String
    var typeOfCall: String
    var date: Date
    var isMissed: Bool
    var isOutgoing: Bool
    
    
}
