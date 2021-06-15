import Foundation
import CoreData

enum TypeOfCall {
    case mobile
    case FaceTime
}

public class RecentStore {
    static var shared = RecentStore()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return container
    }()

    
    var allCalls = [RecentCall]() {
        didSet {
            missedCalls = allCalls.filter { $0.isMissed }
        }
    }
    var missedCalls: [RecentCall]
    
    var callsArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        print(documentDirectory)
        return documentDirectory.appendingPathComponent("calls.json")
    }()
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.MM.yy HH:mm"
        formatter.locale = Locale.current
        return formatter
    }()
    
    init() {
        missedCalls = allCalls.filter { $0.isMissed }
        fetchRecentCalls()
    }
    
    func fetchRecentCalls() {
        do {
            allCalls = try persistentContainer.viewContext.fetch(RecentCall.fetchRequest()).reversed()
        } catch {
            allCalls = []
            print(error)
        }
    }
    
    func deleteCall(_ call: RecentCall) {
        if let index = allCalls.firstIndex(of: call) {
            allCalls.remove(at: index)
        }
    }
    
    func deleteAllRecents() {
        for call in allCalls {
            persistentContainer.viewContext.delete(call)
        }
        allCalls = []
        saveChanges()
    }
    
    func getCall(at indexPath: IndexPath) -> RecentCall {
        return allCalls[indexPath.row]
    }
    
    func getMissedCall(at indexPath: IndexPath) -> RecentCall {
        return missedCalls[indexPath.row]
    }
    
    func addCall(_ number: String, _ type: String, _ date: Date, _ isMissed: Bool = false, isOutgoing: Bool = true) {
        let call = RecentCall(context: persistentContainer.viewContext)
        call.contactName = number
        call.callType = type
        call.date = date
        call.isMissed = isMissed
        call.isOutgoing = isOutgoing
        allCalls.insert(call, at: 0)
        saveChanges()
    }
    
    var count: Int {
        return allCalls.count
    }
    
    var missedCallsCount: Int {
        return missedCalls.count
    }
    
    func saveChanges() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print(error)
        }
    }
}
