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
    
    var contactInfo: ContactInfo!
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
            Section(type: "Message", typeData: contactInfo.phoneNumbers.compactMap({ return "\($0.type)"}), valueData:  contactInfo.phoneNumbers.compactMap({ return "\($0.value)"})),
            Section(type: "Call", typeData: contactInfo.phoneNumbers.compactMap({ return "\($0.type)"}), valueData: contactInfo.phoneNumbers.compactMap({ return "\($0.value)"})),
            Section(type: "Video", typeData: contactInfo.phoneNumbers.compactMap({ return "\($0.type)"}), valueData:contactInfo.phoneNumbers.compactMap({ return "\($0.value)"})),
            Section(type: "Mail", typeData: contactInfo.emails.compactMap({ return "\($0.type)"}), valueData:contactInfo.emails.compactMap({ return "\($0.value)"})),
        ]
//        print(sections[0].typeData)
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
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
            tableView.reloadSections([indexPath.section], with: .none)
        } else {
            for phone in contactInfo!.phoneNumbers {
                let favouritesStore = FavouritesStore.shared
                let favorite = Favourite(context: favouritesStore.persistentContainer.viewContext)
                favorite.contact = contactInfoController.contact
                favorite.label = phone.type
                favorite.phoneNumber = phone.value
                favouritesStore.add(favorite)
            }
            self.dismiss(animated: true)
        }
    }
}


