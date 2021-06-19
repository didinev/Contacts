//
//  AddToFavouritesController.swift
//  Recents
//
//  Created by Dimitar Dinev on 16.06.21.
//

import UIKit
import CoreData

class Section {
    let type: String
    let typeData: [String]
    let valueData: [String]
    var isOpened: Bool = false
    
    init(type: String, typeData: [String], valueData: [String], isOpened: Bool = false) {
        self.type = type
        self.typeData = typeData
        self.valueData = valueData
        self.isOpened = isOpened
    }
}

class AlertViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewTopConstraint: NSLayoutConstraint!
    
    var contact: Contact!
    var phoneNumbers: [ContactInfoItem]!
    var emails: [ContactInfoItem]!
    
    var sections = [Section]()
    
    let cellImage = [
        "message.fill",
        "phone.fill",
        "video.fill",
        "envelope.fill"
    ]
    
    var contactInfoController = ContactInfoViewController.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        sections = [
            Section(type: "Message", typeData: phoneNumbers.compactMap({ return "\($0.type)"}), valueData: phoneNumbers.compactMap({ return "\($0.value)"})),
            Section(type: "Call", typeData: phoneNumbers.compactMap({ return "\($0.type)"}), valueData: phoneNumbers.compactMap({ return "\($0.value)"})),
            Section(type: "Video", typeData: phoneNumbers.compactMap({ return "\($0.type)"}), valueData: phoneNumbers.compactMap({ return "\($0.value)"})),
            Section(type: "Mail", typeData: emails.compactMap({ return "\($0.type)"}), valueData: emails.compactMap({ return "\($0.value)"})),
        ]
        print(sections[0].typeData)
    }
    
    @IBAction func closeAlert(_ sender: Any?) {
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        
        if section.isOpened {
            return section.typeData.count + 1
        }
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if sections[indexPath.section].isOpened == false {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AddToFavouritesCell", for: indexPath) as! AddToFavouritesCell
//            cell.addType.text = sections[indexPath.row].type
//            cell.imgView.image = UIImage(systemName: cellImage[indexPath.row])
//            return cell
//        }
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddToFavouritesCell", for: indexPath) as! AddToFavouritesCell
            cell.addType.text = sections[indexPath.section].type
            cell.imgView.image = UIImage(systemName: cellImage[indexPath.section])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! DataCell
            cell.addType.text = sections[indexPath.section].typeData[indexPath.row - 1]
            cell.value.text = sections[indexPath.section].valueData[indexPath.row - 1]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
            tableViewTopConstraint.constant = view.frame.height - (CGFloat(phoneNumbers.count) * 60) - 180
            tableView.reloadSections([indexPath.section], with: .none)
        } else {
            let favouritesStore = FavouritesStore.shared
            let favourite = Favourite(context: favouritesStore.persistentContainer.viewContext)
            favourite.contact = contactInfoController.contact
            favourite.label = phoneNumbers[indexPath.row - 1].type
            favourite.phoneNumber = phoneNumbers[indexPath.row - 1].value
            favouritesStore.add(favourite)
            favouritesStore.saveChanges()
            self.dismiss(animated: true, completion: nil)
        }
        
        if sections[indexPath.section].isOpened == false {
            tableViewTopConstraint.constant = view.frame.height - (CGFloat(sections.count) * 60) - 120
            tableView.reloadSections([indexPath.section], with: .none)
        }
    }
}


