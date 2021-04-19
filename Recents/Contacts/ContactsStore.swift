import UIKit

struct Contact {
    var name: String
}

class ContactStore {
    var contacts = [
        Contact(name:"Angel"), Contact(name:"Angel2"),
        Contact(name:"Asen"), Contact(name:"Asen2"),
        Contact(name:"Borislav"), Contact(name:"Borislav2"),
        Contact(name:"Bogdan"), Contact(name:"Bogdan2"),
        Contact(name:"Cvetan"), Contact(name:"Cvetan2"),
        Contact(name:"Cvetelina"), Contact(name:"Cvetelina2"),
        Contact(name:"Daniela"), Contact(name:"Daniela2"),
        Contact(name:"Dimitar"), Contact(name:"Dimitar2")
    ]
    
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
