import Foundation

enum TypeOfCall {
    case mobile
    case FaceTime
}

public class RecentStore {
    var allCalls: [RecentCall] {
        didSet {
            missedCalls = allCalls.filter { $0.isMissed }
        }
    }
    var missedCalls: [RecentCall]
    
    init() {
        self.allCalls = [
            RecentCall(name: "Goshko", typeOfCall: "\(TypeOfCall.mobile)", date: Date(), isMissed: true),
            RecentCall(name: "Peshko", typeOfCall: "\(TypeOfCall.FaceTime)", date: Date(), isMissed: false),
            RecentCall(name: "Nasko", typeOfCall: "\(TypeOfCall.mobile)", date: Date(), isMissed: false),
            RecentCall(name: "Vasko", typeOfCall: "\(TypeOfCall.mobile)", date: Date(), isMissed: true),
            RecentCall(name: "Masko", typeOfCall: "\(TypeOfCall.mobile)", date: Date(), isMissed: false),
            RecentCall(name: "Sashko", typeOfCall: "\(TypeOfCall.FaceTime)", date: Date(), isMissed: true),
            RecentCall(name: "Goshko", typeOfCall: "\(TypeOfCall.mobile)", date: Date(), isMissed: true),
            RecentCall(name: "Peshko", typeOfCall: "\(TypeOfCall.FaceTime)", date: Date(), isMissed: false),
            RecentCall(name: "Nasko", typeOfCall: "\(TypeOfCall.mobile)", date: Date(), isMissed: false),
            RecentCall(name: "Vasko", typeOfCall: "\(TypeOfCall.mobile)", date: Date(), isMissed: true),
            RecentCall(name: "Masko", typeOfCall: "\(TypeOfCall.mobile)", date: Date(), isMissed: false),
            RecentCall(name: "Sashko", typeOfCall: "\(TypeOfCall.FaceTime)", date: Date(), isMissed: true)
        ]
        self.missedCalls = allCalls.filter { $0.isMissed }
    }
    
    func deleteCall(_ call: RecentCall) {
        if let index = allCalls.firstIndex(of: call) {
            allCalls.remove(at: index)
        }
    }
    
    func deleteAllRecents() {
        allCalls = []
    }
    
    func getCall(at indexPath: IndexPath) -> RecentCall {
        return allCalls[indexPath.row]
    }
    
    func getMissedCall(at indexPath: IndexPath) -> RecentCall {
        return missedCalls[indexPath.row]
    }
    
    var count: Int {
        return allCalls.count
    }
    
    var missedCallsCount: Int {
        return missedCalls.count
    }
}
