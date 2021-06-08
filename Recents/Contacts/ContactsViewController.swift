import UIKit

class ConstactsViewController : UITableViewController, UISearchResultsUpdating {
    var contactStore = ContactStore.shared
    let searchController = UISearchController()
    var filteredContacts: [Contact] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    @IBOutlet var myCardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        addTopCardLayer()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text?.lowercased() ?? ""
        filteredContacts = contactStore.contacts.filter { (contact: Contact) -> Bool in
            return contact.firstName!.lowercased().hasPrefix(searchText)
        }
        tableView.reloadData()
    }
    
    func addTopCardLayer() {
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: myCardView.frame.size.width, height: 1.0)
        topBorder.backgroundColor = UIColor.placeholderText.cgColor
        myCardView.layer.addSublayer(topBorder)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        return isFiltering ? filteredContacts.count : contactStore.getSectionRowsCount(sectionIndex)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(contactStore.firstLetter[section])
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return isFiltering ? 1 : contactStore.firstLetter.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let contact = isFiltering ? filteredContacts[indexPath.row] : contactStore.getContact(indexPath)
        cell.textLabel?.text = contact.firstName
        cell.textLabel?.font = .boldSystemFont(ofSize: 17)
        
        return cell
    }
    
    @IBAction func createContact(_ sender: Any) {
        let contact = Contact(context: contactStore.persistentContainer.viewContext)
        contact.firstName = "Svetoslav"
        contact.lastName = "Kanchev"
        contact.companyName = "infinno"
        contact.otherData = """
    {
        "phoneNumbers": [
            {
                "type": "mobile",
                "number": "0889 934 358"
            },
            {
                "type": "home",
                "number": "0887 432 962"
            },
            {
                "type": "work",
                "number": "0890 321 416"
            }
        ],
        "emails": [
            {
                "type": "home",
                "email": "sexy_bor4eto@abv.bg"
            },
            {
                "type": "work",
                "email": "dd@infinno.eu"
            }
        ],
        "urls": [
            {
                "type": "home",
                "url": "home.com"
            },
            {
                "type": "work",
                "url": "work.bg"
            }
        ],
        "addresses": [
            {
                "type": "home",
                "address": "Sofia"
            },
            {
                "type": "work",
                "address": "Levunovo"
            }
        ],
        "birthdays": [
           {
               "type": "birthday",
               "date": "27.05.2010"
           }
        ],
        "dates": [
           {
               "type": "anniversary",
               "date": "27.05.2010"
           }
        ]
    }
    """
        
        contactStore.allContacts[contact.firstName!.first!]?.append(contact)
        do {
            try contactStore.persistentContainer.viewContext.save()
        } catch {
            print("error")
        }
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromContacts" {
            let indexPath = tableView.indexPathForSelectedRow
            let contact = contactStore.getContact(indexPath!)
            let callViewController = segue.destination as! CallViewController
            callViewController.call = contact.firstName
        } else if segue.identifier == "contactInfo" {
            let indexPath = tableView.indexPathForSelectedRow
            let contact = contactStore.getContact(indexPath!)
            let viewController = segue.destination as! ContactInfoViewController
            viewController.contact = contact
//            let cell = sender as! UITableViewCell
//            viewController.contactName = cell.textLabel?.text
        }
    }
}
