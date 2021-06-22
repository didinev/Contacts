import UIKit

class RecentViewController: UITableViewController {    
    var recentCalls = RecentStore.shared
    var contact: Contact?
    var idx: IndexPath!
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    @IBOutlet var leftNavBarButton: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recentCalls.fetchRecentCalls()
        print(recentCalls.allCalls)
        tableView.reloadData()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        navigationItem.rightBarButtonItem = editButtonItem
//        tableView.reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        leftNavBarButton.title = isEditing ? "Clear" : ""
        leftNavBarButton.isEnabled = isEditing
    }
    
    @IBAction func clear(_ sender: Any) {
        recentCalls.deleteAllRecents()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let call = segmentControl.selectedSegmentIndex == 0 ? recentCalls.getCall(at: indexPath) : recentCalls.getMissedCall(at: indexPath)
            recentCalls.deleteCall(call)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //eventualno drugo mqsto
        if recentCalls.count == 0 {
            setEmptyMessage("No Items")
        } else {
            restore()
        }
        return segmentControl.selectedSegmentIndex == 0 ? recentCalls.count : recentCalls.missedCallsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentCell", for: indexPath) as! RecentCell
        let call = segmentControl.selectedSegmentIndex == 0 ? recentCalls.getCall(at: indexPath) : recentCalls.getMissedCall(at: indexPath)
        cell.nameLabel.textColor = call.isMissed ? .red : .black
        cell.nameLabel.text = call.contactName
        cell.isOutgoingIcon.isHidden = !call.isOutgoing
        cell.typeOfCallLabel.text = call.callType
        cell.dateLabel.text = getDate(call.date ?? Date())
        
        return cell
    }
    
//    var indexOfRexentCallsToOpen: IndexPath!
    var contactToOpen: Contact!
    var recentCallStore = RecentStore.shared
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        contact = recentCalls.getCall(at: indexPath).contacts
        print(contact)
        idx = indexPath
        performSegue(withIdentifier: "showContactFromRecents", sender: (Any).self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContactFromRecents" {
            let contactController = segue.destination as! ContactInfoViewController
            
            contactController.contact = contact
            contactController.contactInfo = ContactInfo()
            //contactController.recentCalls = recentCallStore.allCalls.first(where: { $0.first?.contact == contactToOpen })
//            contactController.recentCalls = recentCallStore.getCalls(at: indexOfRexentCallsToOpen)
        }
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        messageLabel.text = message
        messageLabel.textAlignment = .center

        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }

    func restore() {
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
    }
    
    let todayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    let lastWeekDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    let moreThanWeekDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d.MM.yy"
        return formatter
    }()

    let weekDuration = TimeInterval(60 * 60 * 24 * 7)
    
    func getDate(_ date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return todayDateFormatter.string(from: date)
        } else if Calendar.current.isDateInYesterday(date) {
            return "Yesterday"
        } else if date.distance(to: Date()) < weekDuration {
            return lastWeekDateFormatter.string(from: date)
        } else {
            return moreThanWeekDateFormatter.string(from: date)
        }
    }
}
