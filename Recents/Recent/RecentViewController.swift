import UIKit

class RecentViewController: UITableViewController {    
    var allCalls = RecentStore()
    
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    @IBOutlet var rightNavBarButton: UIBarButtonItem!
    @IBOutlet var leftNavBarButton: UIBarButtonItem!
    
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        isEditing.toggle()
        if isEditing {
            rightNavBarButton.title = "Done"
            leftNavBarButton.isEnabled = true
            leftNavBarButton.title = "Clear"
        } else {
            rightNavBarButton.title = "Edit"
            leftNavBarButton.isEnabled = false
            leftNavBarButton.title = ""
        }
    }
    
    @IBAction func clear(_ sender: Any) {
        allCalls.deleteAllRecents()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let call = segmentControl.selectedSegmentIndex == 0 ? allCalls.getCall(at: indexPath) : allCalls.getMissedCall(at: indexPath)
            allCalls.deleteCall(call)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //eventualno drugo mqsto
        if allCalls.count == 0 {
            setEmptyMessage("No Items")
        } else {
            restore()
        }
        return segmentControl.selectedSegmentIndex == 0 ? allCalls.count : allCalls.missedCallsCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentCell", for: indexPath) as! RecentCell
        let call = segmentControl.selectedSegmentIndex == 0 ? allCalls.getCall(at: indexPath) : allCalls.getMissedCall(at: indexPath)
        cell.nameLabel.textColor = call.isMissed ? .red : .black
        cell.nameLabel.text = call.name
        cell.isOutgoingIcon.isHidden = !call.isOutgoing
        cell.typeOfCallLabel.text = call.typeOfCall
        cell.dateLabel.text = call.formattedDate
        
        return cell
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
}
