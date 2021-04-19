import UIKit

class ConstactsViewController : UITableViewController {
    var contactStore = ContactStore()
    
    @IBOutlet var myCardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.searchController = UISearchController()
        navigationController?.navigationItem.hidesSearchBarWhenScrolling = false
        
        addTopCardLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func addTopCardLayer() {
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: myCardView.frame.size.width, height: 1.0)
        topBorder.backgroundColor = UIColor.placeholderText.cgColor
        myCardView.layer.addSublayer(topBorder)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection sectionIndex: Int) -> Int {
        return contactStore.getRowsPerSection(sectionIndex)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(contactStore.firstLetter[section])
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactStore.firstLetter.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let contact = contactStore.getContact(indexPath)
        cell.textLabel?.text = contact.name
        cell.textLabel?.font = .boldSystemFont(ofSize: 17)
        return cell
    }
}
