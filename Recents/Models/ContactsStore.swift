import UIKit
import CoreData

class ContactStore {
    static var shared = ContactStore()
    var allContacts: Dictionary<Character, [Contact]> = [:]
    var sections: [Character] = []
    var contacts: [Contact] = []
    
//    var contactsArchiveURL: URL = {
//        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentDirectory = documentsDirectories.first!
//        return documentDirectory.appendingPathComponent("contacts.json")
//    }()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return container
    }()
    
    init() {
        updateContacts()

//        let entityNames = persistentContainer.managedObjectModel.entities.map({ $0.name!})
//        entityNames.forEach { entityName in
//            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
//            
//            do {
//                try persistentContainer.viewContext.execute(deleteRequest)
//                try persistentContainer.viewContext.save()
//            } catch {
//                print(error)
//            }
//        }
    }
    
    func updateContacts() {
        let context = persistentContainer.viewContext

        do {
            contacts = try context.fetch(Contact.fetchRequest())
            allContacts = Dictionary(grouping: contacts, by: { $0.firstName!.first!})
            sections = Set(contacts.map { $0.firstName!.first! }).sorted()
        } catch {
            allContacts = Dictionary()
            sections = []
            contacts = []
            print(error)
        }
    }
    
    func saveChanges() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print(error)
        }
    }
    
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






//        if contacts.isEmpty {
//            let contact = Contact(context: context)
//            contact.firstName = "Gigi"
//            contact.otherData = """
//    {
//        "phoneNumbers": [
//            {
//                "type": "mobile",
//                "value": "0889 934 358"
//            },
//            {
//                "type": "home",
//                "value": "0887 432 962"
//            },
//            {
//                "type": "work",
//                "value": "0890 321 416"
//            }
//        ],
//        "emails": [
//            {
//                "type": "home",
//                "value": "sexy_bor4eto@abv.bg"
//            },
//            {
//                "type": "work",
//                "value": "dd@infinno.eu"
//            }
//        ],
//        "urls": [
//            {
//                "type": "home",
//                "value": "home.com"
//            },
//            {
//                "type": "work",
//                "value": "work.bg"
//            }
//        ],
//        "addresses": [
//            {
//                "type": "home",
//                "value": "Sofia"
//            },
//            {
//                "type": "work",
//                "value": "Levunovo"
//            }
//        ],
//        "birthdays": [
//           {
//               "type": "birthday",
//               "value": "27.05.2010"
//           }
//        ],
//        "dates": [
//           {
//               "type": "anniversary",
//               "value": "27.05.2010"
//           }
//        ]
//    }
//    """
//            contacts.append(contact)
//        }
//        do {
//            try context.save()
//        } catch {
//            print("Error saving to Core Data", error)
//        }
//
//        allContacts = Dictionary(grouping: contacts, by: { $0.firstName?.first! ?? "s"})
//        sections = Set(contacts.map { $0.firstName?.first! ?? "s"}).sorted()
