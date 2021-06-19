//
//  EditContactViewController.swift
//  Recents
//
//  Created by Dimitar Dinev on 31.05.21.
//

import UIKit

enum CellType: String {
    case phoneNumber
    case notes
    case basic
}

class ContactInfoViewController: UITableViewController {
    @IBOutlet var contactFirstLetter: UILabel!
    @IBOutlet var contactNameLabel: UILabel!
    @IBOutlet var navBar: UINavigationItem!
    @IBOutlet var titleView: UIView!
    
    static var shared = ContactInfoViewController()
    
    var contact: Contact!
    var contactInfo: ContactInfo?
    
    var sectionRows: [[(info: Any, type: CellType)]] = [
        [("Notes", .notes)],
        [("Send Message", .basic), ("Share Contact", .basic), ("Add to Favourites", .basic)],
        [("Add to Emergency Contacts", .basic)],
        [("Share My Location", .basic)],
        [("Block this Caller", .basic)]
    ]
    
    var sectionRowsCopy: [[(info: Any, type: CellType)]] = [
        [("Notes", .notes)],
        [("Send Message", .basic), ("Share Contact", .basic), ("Add to Favourites", .basic)],
        [("Add to Emergency Contacts", .basic)],
        [("Share My Location", .basic)],
        [("Block this Caller", .basic)]
    ]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        contactFirstLetter.text = "\(contact.firstName!.first!)"
        contactNameLabel.text = contact.firstName
        updateData()
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateData()
        contactFirstLetter.text = "\(contact.firstName!.first!)"
        contactNameLabel.text = contact.firstName
    }
    
    func updateData() {
        contactNameLabel.text = contact!.firstName
        sectionRows = sectionRowsCopy
        do {
            let jsonData = contact.otherData?.data(using: .utf8)
            contactInfo = try JSONDecoder().decode(ContactInfo.self, from: jsonData!)
            if !contactInfo!.dates.isEmpty {
                sectionRows.insert([], at: 0)
                contactInfo!.dates.forEach { sectionRows[0].append((($0.type, $0.value), .phoneNumber)) }
            }
            if !contactInfo!.birthdays.isEmpty {
                sectionRows.insert([], at: 0)
                contactInfo!.birthdays.forEach { sectionRows[0].append((($0.type, $0.value), .phoneNumber)) }
            }
            if !contactInfo!.addresses.isEmpty {
                sectionRows.insert([], at: 0)
                contactInfo!.addresses.forEach { sectionRows[0].append((($0.type, $0.value), .phoneNumber)) }
            }
            if !contactInfo!.urls.isEmpty {
                sectionRows.insert([], at: 0)
                contactInfo!.urls.forEach { sectionRows[0].append((($0.type, $0.value), .phoneNumber)) }
            }
            if !contactInfo!.emails.isEmpty {
                sectionRows.insert([], at: 0)
                contactInfo!.emails.forEach { sectionRows[0].append((($0.type, $0.value), .phoneNumber)) }
            }
            if !contactInfo!.phoneNumbers.isEmpty {
                sectionRows.insert([], at: 0)
                contactInfo!.phoneNumbers.forEach { sectionRows[0].append((($0.type, $0.value), .phoneNumber)) }
            }
        } catch {
            print(error)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionRows.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionRows[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = sectionRows[indexPath.section].last!.1
        switch cellType {
        case .phoneNumber:
            return 70
        case .notes:
            return 100
        default:
            return 45
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == tableView.numberOfSections - 1 ? 35 : 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionData = sectionRows[indexPath.section][indexPath.row]
        
        switch sectionData.type {
        case .basic:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelWithButtonCell", for: indexPath)
            cell.textLabel?.text = sectionData.info as? String
            cell.textLabel?.textColor = cell.textLabel?.text == "Block this Caller" ? .systemRed : .systemBlue
            return cell
        case .notes:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! InfoTextLabel
            let cellData = sectionRows[indexPath.section][indexPath.row].info as! (String, String)
            cell.typeLabel.text = "\(cellData.0)"
            cell.contentLabel.text = "\(cellData.1)"
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case "editContact":
            let viewController = segue.destination as! EditingViewController
            viewController.contact = contact
            viewController.contactInfo = contactInfo
        case "callContact":
            let callController = segue.destination as! CallViewController
            let indexPath = tableView.indexPathForSelectedRow!
            if indexPath.section != 0 {
                return
            }
            let callLabel = "\(contact.firstName!) \(contact.lastName ?? "")"
            let callType = contactInfo!.phoneNumbers[indexPath.row].type
            callController.phoneNumber = callLabel
            RecentStore.shared.addCall(callLabel, callType, Date())
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let cell = cell, cell.textLabel?.text == "Add to Favourites" {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let myAlert = storyboard.instantiateViewController(withIdentifier: "AlertViewController")
            myAlert.modalPresentationStyle = .popover
            myAlert.modalTransitionStyle = .crossDissolve
            let vc = myAlert as! AlertViewController
            vc.contact = self.contact
            vc.phoneNumbers = self.contactInfo?.phoneNumbers
            vc.emails = self.contactInfo?.emails
            self.present(myAlert, animated: true)
        }
    }
}
