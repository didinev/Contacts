import Foundation

enum TypeOfCall {
    case mobile
    case FaceTime
}

public class RecentStore {
    var allCalls: [Call] {
        didSet {
            missedCalls = allCalls.filter { $0.isMissed }
        }
    }
    var missedCalls: [Call]
    
    init() {
        self.allCalls = [
            Call(name: "Goshko", typeOfCall: "\(TypeOfCall.mobile)", date: Date(), isMissed: true),
            Call(name: "Peshko", typeOfCall: "\(TypeOfCall.FaceTime)", date: Date(), isMissed: false),
            Call(name: "Nasko", typeOfCall: "\(TypeOfCall.mobile)", date: Date(), isMissed: false),
            Call(name: "Vasko", typeOfCall: "\(TypeOfCall.mobile)", date: Date(), isMissed: true),
            Call(name: "Masko", typeOfCall: "\(TypeOfCall.mobile)", date: Date(), isMissed: false),
            Call(name: "Sashko", typeOfCall: "\(TypeOfCall.FaceTime)", date: Date(), isMissed: true),
            Call(name: "Goshko", typeOfCall: "\(TypeOfCall.mobile)", date: Date(), isMissed: true),
            Call(name: "Peshko", typeOfCall: "\(TypeOfCall.FaceTime)", date: Date(), isMissed: false),
            Call(name: "Nasko", typeOfCall: "\(TypeOfCall.mobile)", date: Date(), isMissed: false),
            Call(name: "Vasko", typeOfCall: "\(TypeOfCall.mobile)", date: Date(), isMissed: true),
            Call(name: "Masko", typeOfCall: "\(TypeOfCall.mobile)", date: Date(), isMissed: false),
            Call(name: "Sashko", typeOfCall: "\(TypeOfCall.FaceTime)", date: Date(), isMissed: true)
        ]
        self.missedCalls = allCalls.filter { $0.isMissed }
    }
    
    func deleteCall(_ call: Call) {
        if let index = allCalls.firstIndex(of: call) {
            allCalls.remove(at: index)
        }
    }
    
    func deleteAllRecents() {
        allCalls = []
    }
    
    func getCall(at indexPath: IndexPath) -> Call {
        return allCalls[indexPath.row]
    }
    
    func getMissedCall(at indexPath: IndexPath) -> Call {
        return missedCalls[indexPath.row]
    }
    
    var count: Int {
        return allCalls.count
    }
    
    var missedCallsCount: Int {
        return missedCalls.count
    }
}
