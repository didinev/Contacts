//
//  EditContactViewController.swift
//  Recents
//
//  Created by Dimitar Dinev on 31.05.21.
//

import UIKit

class ContactInfoViewController: UITableViewController {
    @IBOutlet var contactFirstLetter: UILabel!
    @IBOutlet var contactNameLabel: UILabel!
    
    var contactName: String!
    var phoneNumbers: [(label: String, number: String)] = [
        ("home", "0893725151")
    ]
    
    let sectionRows = [
        ["home"],
        ["Notes"],
        ["Send Message", "Share Contact", "Add to favourites"],
        ["Add To Emergency Contacts"],
        ["Share My Location"],
        ["Block this Caller"],
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactFirstLetter.text = "\(contactName.first!)"
        contactNameLabel.text = contactName
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionRows.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionRows[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 75
        case 1:
            return 150
        default:
            return 50
        }
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 17.5
//    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == tableView.numberOfSections - 1 ? 35 : 0
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = .systemGray6
//        return view
//    }
//    
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let view = UIView()
//        view.backgroundColor = .systemGray6
//        return view
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let name = sectionRows[indexPath.section][indexPath.row]
        
        switch name {
        case "Home":
            cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
            cell.textLabel?.text = name
        case "Notes":
            cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath)
//            cell.textLabel?.text = name
//            cell.textLabel?.textColor = UIColor.lightGray
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "LabelWithButtonCell", for: indexPath)
            cell.textLabel?.text = name
            cell.textLabel?.textColor = cell.textLabel?.text == "Block this Caller" ? .systemRed : .systemBlue
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case "editContact":
            let viewController = segue.destination as! EditingViewController
            viewController.name = self.contactName
            viewController.phoneNumbers = self.phoneNumbers
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}

class InfoTextLabel: UITableViewCell {
    @IBOutlet var tagType: UILabel!
    @IBOutlet var tagContent: UILabel!
}
