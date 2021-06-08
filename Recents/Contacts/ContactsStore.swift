import UIKit
import CoreData

class ContactStore {
    static var shared = ContactStore()
//    let contacts = [
//        ("Daniela", "Palova", "infinno"),
//        ("Dimitar", "Dinev", "infinno"),
//        ("Emilia", "Nedyalkova", "infinno"),
//        ("Georgi", "Tsonev", "infinno"),
//        ("Svetoslav", "Kanchev", "infinno")
//    ].map { Contacts(firstName: $0.0, lastName: $0.1, companyName: $0.2) }
    
    var allContacts: Dictionary<Character, [Contact]>
    var sections: [Character]
    let contacts: [Contact]
    
    var contactsArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("contacts.json")
    }()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ContactDataModel")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return container
    }()
    
    init() {
        let context = persistentContainer.viewContext
        do {
            contacts = try context.fetch(Contact.fetchRequest())
            allContacts = Dictionary(grouping: contacts, by: { $0.firstName!.first! })
            sections = Set(contacts.map { $0.firstName!.first! }).sorted()
        } catch {
            allContacts = Dictionary()
            sections = []
            contacts = []
            print(error)
        }
    }
    
//    init() {
//        allContacts = Dictionary(grouping: contacts, by: { $0.firstName.first! })
//        sections = Set(contacts.map { $0.firstName.first! }).sorted()
////        do {
////            let data = try Data(contentsOf: contactsArchiveURL)
////            let decoder = JSONDecoder()
////            contacts = try decoder.decode([Contact].self, from: data)
////        } catch {
////            contacts = [Contact]()
////            print("Error reading items \(error)")
////        }
//    }
    
    var sectionsCount: Int {
        return sections.count
    }
    
    var firstLetter: [Character] {
        var firstLetters = Set<Character>()
        contacts.forEach { firstLetters.insert($0.firstName!.first!) }
        return firstLetters.sorted()
    }
    
    func getSectionRowsCount(_ section: Int) -> Int {
        let firstLetter = sections[section]
        return allContacts[firstLetter]?.count ?? 0
    }
    
    func getSectionName(_ section: Int) -> Character {
        return sections[section]
    }
    
    func getContact(_ indexPath: IndexPath) -> Contact {
        let firstLetter = sections[indexPath.section]
        return allContacts[firstLetter]![indexPath.row]
    }
}
