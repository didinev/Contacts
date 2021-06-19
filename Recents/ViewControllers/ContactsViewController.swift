import UIKit

class ContactsViewController : UITableViewController, UISearchResultsUpdating {
    var contactStore = ContactStore.shared
    let searchController = UISearchController()
    var filteredContacts: [Contact] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    var isFromFavourite = false
    
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
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
    
            contactStore.updateContacts()
            tableView.reloadData()
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
        } else if segue.identifier == "addContact" {
            let viewController = segue.destination as! EditingViewController
            viewController.contact = Contact(context: contactStore.persistentContainer.viewContext)
            viewController.contactInfo = ContactInfo()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isFromFavourite {
            performSegue(withIdentifier: "contactInfo", sender: (Any).self)
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "AlertViewController")
        myAlert.modalPresentationStyle = .popover
        myAlert.modalTransitionStyle = .crossDissolve
        let alertController = myAlert as! AlertViewController
        let contact = contactStore.getContact(indexPath)
        var contactInfo = ContactInfo()
        do {
            let jsonData = contact.otherData?.data(using: .utf8)
            contactInfo = try JSONDecoder().decode(ContactInfo.self, from: jsonData!)
        } catch {
            print(error)
        }
        alertController.contact = contact
        alertController.phoneNumbers = contactInfo.phoneNumbers
        alertController.emails = contactInfo.emails
        self.present(myAlert, animated: true)
    }
}




















//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        contactStore.fetchContacts()
//        tableView.reloadData()
//    }



//@IBAction func createContact(_ sender: Any) {
//    let contact = Contact(context: contactStore.persistentContainer.viewContext)
//    contact.firstName = "Dimitar"
//    contact.lastName = "Dinev"
//    contact.companyName = "Infinno"
//
//    contact.otherData = """
//{
//    "phoneNumbers": [
//        {
//            "type": "mobile",
//            "value": "0889 934 358"
//        },
//        {
//            "type": "home",
//            "value": "0887 432 962"
//        },
//        {
//            "type": "work",
//            "value": "0890 321 416"
//        }
//    ],
//    "emails": [
//        {
//            "type": "home",
//            "value": "sexy_bor4eto@abv.bg"
//        },
//        {
//            "type": "work",
//            "value": "dd@infinno.eu"
//        }
//    ],
//    "urls": [
//        {
//            "type": "home",
//            "value": "home.com"
//        },
//        {
//            "type": "work",
//            "value": "work.bg"
//        }
//    ],
//    "addresses": [
//        {
//            "type": "home",
//            "value": "Sofia"
//        },
//        {
//            "type": "work",
//            "value": "Levunovo"
//        }
//    ],
//    "birthdays": [
//       {
//           "type": "birthday",
//           "value": "27.05.2010"
//       }
//    ],
//    "dates": [
//       {
//           "type": "anniversary",
//           "value": "27.05.2010"
//       }
//    ],
//        "relatedNames": [
//           {
//               "type": "birthday",
//               "value": "27.05.2010"
//           }
//        ],
//        "socialProfiles": [
//           {
//               "type": "birthday",
//               "value": "27.05.2010"
//           }
//        ],
//        "instantMessages": [
//           {
//               "type": "birthday",
//               "value": "27.05.2010"
//           }
//        ],
//}
//"""
//
//    contactStore.allContacts[contact.firstName!.first!]?.append(contact)
//    do {
//        try contactStore.persistentContainer.viewContext.save()
//    } catch {
//        print("error")
//    }
//}
