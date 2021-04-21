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
    
    var callsArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("calls.json")
    }()
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.MM.yy HH:mm"
        formatter.locale = Locale.current
        return formatter
    }()
    
    init() {
        do {
            let data = try Data(contentsOf: callsArchiveURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .formatted(RecentStore.formatter)
            allCalls = try decoder.decode([Call].self, from: data)
        } catch {
            allCalls = [Call]()
            print("Error reading items \(error)")
        }
        self.missedCalls = allCalls.filter { $0.isMissed }
    }
    
//    init() {
//        let path = Bundle.main.url(forResource: "calls", withExtension: "json")!
//        do {
//            let jsonData = try Data(contentsOf: path)
//            allCalls = try JSONDecoder().decode([Call].self, from: jsonData)
//        } catch {
//            allCalls = [Call]()
//            print("Error reading items \(error)")
//        }
//        self.missedCalls = allCalls.filter { $0.isMissed }
//    }
    
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
