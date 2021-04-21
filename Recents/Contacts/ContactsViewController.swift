import UIKit

class ConstactsViewController : UITableViewController, UISearchResultsUpdating {
    var contactStore = ContactStore()
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
            return contact.name.lowercased().hasPrefix(searchText)
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
        return isFiltering ? filteredContacts.count : contactStore.getRowsPerSection(sectionIndex)
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
        cell.textLabel?.text = contact.name
        cell.textLabel?.font = .boldSystemFont(ofSize: 17)
        return cell
    }
}
