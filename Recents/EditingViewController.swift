//
//  EditingViewController.swift
//  Recents
//
//  Created by Dimitar Dinev on 1.06.21.
//

import UIKit
import CoreData

class EditingViewController: UITableViewController {
    @IBOutlet var firstLetterLabel: UILabel!
    
    var contacts = ContactStore.shared
    var contact: Contact!
    var contactInfo: ContactInfo?
    
    var sectionNames = [
        "neshto",
        "add phone",
        "add email",
        "Ringtone",
        "Text Tone",
        "add url",
        "add address",
        "add birthday",
        "add date",
        "add related name",
        "add social profile",
        "add instant message",
        "Notes",
        "add field",
        "link contacts...",
        "Delete Contact",
    ]
    
    let tagController = TagsViewController()
    var currentTag = 1
    var isInitialCell = true
    
    @IBAction func cancel(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Are you sure you want to discard your changes?", preferredStyle: .actionSheet)
        
        
        alert.addAction(UIAlertAction(title: "Discard Changes", style: .destructive, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Keep Editing", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        let phoneSection = getArrayPerSection(1)
        let emailSection = getArrayPerSection(2)
        let urlSection = getArrayPerSection(5)
        let addressSection = getArrayPerSection(6)
        let dateSection = getArrayPerSection(8)
        let birthdaySection = getArrayPerSection(7)
        
        contactInfo!.phoneNumbers = phoneSection
        contactInfo!.emails = emailSection
        contactInfo!.addresses = addressSection
        contactInfo!.urls = urlSection
        contactInfo!.dates = dateSection
        contactInfo!.birthdays = birthdaySection
        
        do {
            let str = try JSONEncoder().encode(contactInfo)
            contact.otherData = String(data: str, encoding: .utf8)!
        } catch {
            print(error)
        }

        contacts.saveChanges()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstLetterLabel.text = contact.firstName?.first != nil ? String(contact.firstName!.first!) : ""
        tableView.setEditing(true, animated: false)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let keyPath = ciKeyPaths[indexPath.section]

        if editingStyle == .delete {
            contactInfo![keyPath: keyPath].remove(at: indexPath.row)
//            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        if editingStyle == .insert {
            currentTag = currentTag + 1
            if currentTag >= tagController.tags.count {
                currentTag = 0
            }
            let contactInfoItem = ContactInfoItem(type: tagController.tags[currentTag], value: "")
            contactInfo![keyPath: keyPath].append(contactInfoItem)
            tableView.insertRows(at: [IndexPath(row: contactInfo![keyPath: keyPath].count - 1, section: indexPath.section)], with: .automatic)
            isInitialCell = false
            
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0, 3, 4, 12, 13, 15:
            return false
        default:
            return true
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        let totalRow = tableView.numberOfRows(inSection: indexPath.section)
        
        return indexPath.row == totalRow - 1 ? .insert : .delete
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 16
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        
        guard let _ = contactInfo else { return 1 }
        
        let sectionItems = getArrayPerSection(section)
        switch section {
        case 0:
            return 3
        case 1, 2, 5, 7, 8, 9, 10, 11:
            return sectionItems.count + 1
        default:
            return 1
        }
    }
    
    var ciKeyPaths = [
        \ContactInfo.phoneNumbers,
        \ContactInfo.phoneNumbers,
        \ContactInfo.emails,
        \ContactInfo.urls,
        \ContactInfo.addresses,
        \ContactInfo.birthdays,
        \ContactInfo.dates,
//        \ContactInfo.relatedNames,
//        \ContactInfo.socialProfiles,
//        \ContactInfo.instantMessages,
    ]
    
    func getArrayPerSection(_ section: Int) -> [ContactInfoItem] {
        if section >= ciKeyPaths.count {
            return []
        }

        let keyPath = ciKeyPaths[section]
        return contactInfo![keyPath: keyPath]
    }
    
    func editArrayPerSection(_ indexPath: IndexPath, _ value: String?) {
        if indexPath.section >= ciKeyPaths.count {
            return
        }

        let keyPath = ciKeyPaths[indexPath.section]
        contactInfo![keyPath: keyPath][indexPath.row].value = value ?? ""
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 12 ? 150 : 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UIView()
        label.backgroundColor = .systemGray6
        return label
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UIView()
        label.backgroundColor = .clear
        return label
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let addButtonLabel = sectionNames[indexPath.section]
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
            cell.textField.placeholder = addButtonLabel
            
            switch indexPath.row {
            case 0:
                cell.textField.text = contact.firstName
            case 1:
                cell.textField.text = contact.lastName
            default:
                cell.textField.text = contact.companyName
            }
            cell.textField.indexPath = indexPath
            cell.textField.addTarget(self, action: #selector(nameChanged), for: .editingDidEnd)
            return cell
        case 3, 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelWithButtonCell", for: indexPath) as! ButtonCell
            cell.txtLabel?.text = addButtonLabel
            cell.accessoryType = .disclosureIndicator
            return cell
        case 12:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath)
            return cell
        case 15:
            let cell = tableView.dequeueReusableCell(withIdentifier: "deleteCell", for: indexPath) as! DeleteCell
            cell.btn.setTitle(sectionNames[indexPath.section], for: .normal)
//            cell.isHidden = !isDeleteEnabled
            return cell
        default:
            let sectionItems = getArrayPerSection(indexPath.section)
            let totalRows = tableView.numberOfRows(inSection: indexPath.section)
            
            if totalRows - 1 == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddCells", for: indexPath) as! AddCell
                cell.txtLabel.text = addButtonLabel
                cell.txtLabel.textColor = cell.txtLabel?.text == "Delete Contact" ? .systemRed : .systemBlue
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCells", for: indexPath) as! LabelCell
                
                let item = sectionItems[indexPath.row]
                
                cell.txtLabel.text = item.type
                
                cell.textField.increaseSize(cell.txtLabel)
                cell.textField.text = item.value
                
                cell.textField.indexPath = indexPath
                cell.textField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
                
                let gradient = CAGradientLayer()
                gradient.colors = [UIColor.white.cgColor, UIColor.systemGray2.cgColor]
                gradient.frame = CGRect(x: -5, y: 0, width: 1, height: cell.bounds.height)
                cell.textField.layer.addSublayer(gradient)
                
                if !isInitialCell {
                    cell.textField.becomeFirstResponder()
                }
                
                return cell
            }
        }
    }
    
    @objc func textChanged(_ textField: CustomTextField) {
        editArrayPerSection(textField.indexPath, textField.text)
    }
    
    @objc func nameChanged(_ sender: CustomTextField) {
        switch sender.indexPath.row {
        case 0:
            if sender.text == nil || sender.text!.isEmpty {
                navigationItem.rightBarButtonItem?.isEnabled = false
                return
            }
            contact.firstName = sender.text!
            navigationItem.rightBarButtonItem?.isEnabled = true
        case 1:
            contact.lastName = sender.text
        default:
            contact.companyName = sender.text
        }
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "contactInfo" {
//            let viewController = segue.destination as! TagsViewController
//            let button = sender as! UIButton
//            viewController.button = button
////            cell.textLabel?.text = viewController.contactName
//        }
        
//        if segue.identifier == "tagSegue" {
//            let navController = segue.destination as! UINavigationController
//            let tagsViewController = navController.topViewController as! TagsViewController
//            let label = 
//            tagsViewController.currentLabel = label
//            tagsViewController.btn = btn
//            tagsViewController.editContactViewController = self
//        }
    }
}

















//        contactInfo!.birthdays = birthdaySection.map { ContactInfoItem(type: $0.type, value: $0.value) }
//        contactInfo.emails = sectionNames["email"]!.filter { $0.1 != nil }.map { ContactInfoItem(label: $0.0, value: $0.1!) }
//        contactInfo.urls = sectionNames["url"]!.filter { $0.1 != nil }.map { ContactInfoItem(label: $0.0, value: $0.1!) }
//        contactInfo.dates = sectionNames["date"]!.filter { $0.1 != nil }.map { ContactInfoItem(label: $0.0, value: $0.1!) }
//        contactInfo.birthdays = sectionNames["birthday"]!.filter { $0.1 != nil }.map { ContactInfoItem(label: $0.0, value: $0.1!) }
