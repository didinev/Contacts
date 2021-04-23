import UIKit

struct Contact: Codable {
    var name: String
}

class ContactStore {
    var contacts: [Contact]
    
    var contactsArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        print(documentDirectory)
        return documentDirectory.appendingPathComponent("contacts.json")
    }()
    
    init() {
        do {
            let data = try Data(contentsOf: contactsArchiveURL)
            let decoder = JSONDecoder()
            contacts = try decoder.decode([Contact].self, from: data)
        } catch {
            contacts = [Contact]()
            print("Error reading items \(error)")
        }
    }
    
//    init() {
//        let path = Bundle.main.url(forResource: "contacts", withExtension: "json")!
//        do {
//            let jsonData = try Data(contentsOf: path)
//            contacts = try JSONDecoder().decode([Contact].self, from: jsonData)
//        } catch {
//            contacts = [Contact]()
//            print("Error reading items \(error)")
//        }
//    }
    
    var firstLetter: [Character] {
        var firstLetters = Set<Character>()
        contacts.forEach { firstLetters.insert($0.name.first!) }
        return firstLetters.sorted()
    }
    
    func getRowsPerSection(_ section: Int) -> Int {
        let character = String(firstLetter[section])
        return contacts.reduce(0) { $1.name.hasPrefix(character) ? $0 + 1 : $0 }
    }
    
    func getContact(_ indexPath: IndexPath) -> Contact {
        let character = firstLetter[indexPath.section]
        return contacts.filter { $0.name.contains(character) }[indexPath.row]
    }
}
