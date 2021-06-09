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
    
    var contact: Contact!
    var contactInfo: ContactInfo?
    
    var contactName: String!
    
    var sectionRows: [[(info: Any, type: CellType)]] = [
        [("Notes", .notes)],
        [("Send Message", .basic), ("Share Contact", .basic), ("Add to Favorites", .basic)],
        [("Add to Emergency Contacts", .basic)],
        [("Share My Location", .basic)],
        [("Block this Caller", .basic)]
    ]
    
    var info = """
    {
        "phoneNumbers": [
            {
                "type": "mobile",
                "value": "0889 934 358"
            },
            {
                "type": "home",
                "value": "0887 432 962"
            },
            {
                "type": "work",
                "value": "0890 321 416"
            }
        ],
        "emails": [
            {
                "type": "home",
                "value": "sexy_bor4eto@abv.bg"
            },
            {
                "type": "work",
                "value": "dd@infinno.eu"
            }
        ],
        "urls": [
            {
                "type": "home",
                "value": "home.com"
            },
            {
                "type": "work",
                "value": "work.bg"
            }
        ],
        "addresses": [
            {
                "type": "home",
                "value": "Sofia"
            },
            {
                "type": "work",
                "value": "Levunovo"
            }
        ],
        "birthdays": [
           {
               "type": "birthday",
               "value": "27.05.2010"
           }
        ],
        "dates": [
           {
               "type": "anniversary",
               "value": "27.05.2010"
           }
        ]
    }
    """
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let jsonData = contact.otherData!.data(using: .utf8)
            contactInfo = try JSONDecoder().decode(ContactInfo.self, from: jsonData!)
            print(contactInfo!.phoneNumbers)
//            print(contactInfo.phoneNumbers, contactInfo?.addresses, contactInfo?.birthdays, "arrays")
            
            sectionRows.insert([], at: 0)
            contactInfo!.phoneNumbers.forEach { sectionRows[0].append((($0.type, $0.value), .phoneNumber)) }
            
            sectionRows.insert([], at: 1)
            contactInfo!.emails.forEach { sectionRows[1].append((($0.type, $0.value), .phoneNumber)) }
            
            sectionRows.insert([], at: 2)
            contactInfo!.urls.forEach { sectionRows[2].append((($0.type, $0.value), .phoneNumber)) }
            
            sectionRows.insert([], at: 3)
            contactInfo!.addresses.forEach { sectionRows[3].append((($0.type, $0.value), .phoneNumber)) }
            
            sectionRows.insert([], at: 4)
            contactInfo!.birthdays.forEach { sectionRows[4].append((($0.type, $0.value), .phoneNumber)) }
            
            sectionRows.insert([], at: 5)
            contactInfo!.dates.forEach { sectionRows[5].append((($0.type, $0.value), .phoneNumber)) }
        } catch {
            print(error)
        }
        
        contactFirstLetter.text = "\(contact.firstName!.first!)"
        contactNameLabel.text = contact.firstName
        for el in sectionRows {
            print(el)
        }
//        print(sectionRows.count, "asdasdf")
//        print(contactInfo?.phoneNumbers.count, "phone numbers")
//        print(contact.otherData, "other data")
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
//        let cell: UITableViewCell
        let sectionData = sectionRows[indexPath.section][indexPath.row]
        
        switch sectionData.type {
        case .phoneNumber:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! InfoTextLabel
            let cellData = sectionRows[indexPath.section][indexPath.row].info as! (String, String)
            cell.typeLabel.text = "\(cellData.0)"
            cell.contentLabel.text = "\(cellData.1)"
//            cell.textLabel?.text = "asd"
            return cell
//            cell.textLabel?.text = name
        case .notes:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath)
            return cell
//            cell.textLabel?.text = name
//            cell.textLabel?.textColor = UIColor.lightGray
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelWithButtonCell", for: indexPath)
            cell.textLabel?.text = sectionData.info as? String
            cell.textLabel?.textColor = cell.textLabel?.text == "Block this Caller" ? .systemRed : .systemBlue
            return cell
        }
        
//        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier {
        case "editContact":
            let viewController = segue.destination as! EditingViewController
            viewController.contact = contact
            viewController.contactInfo = contactInfo
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
}
