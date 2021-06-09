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
    
    @IBAction func cancel(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Are you sure you want to discard your changes?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Discard Changes", style: .destructive, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Keep Editing", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func done(_ sender: Any) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
//        
        let viewController = ContactInfoViewController()
        viewController.contactName = "self.name"
        self.navigationController?.popViewController(animated: true)
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstLetterLabel.text = "\(contact.firstName!.first!)"
        tableView.setEditing(true, animated: false)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var sectionItems = getArrayPerSection(indexPath.section)

        if editingStyle == .delete {
            sectionItems.remove(at: indexPath.row)
//            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        if editingStyle == .insert {
            currentTag = currentTag + 1
            if currentTag >= tagController.tags.count {
                currentTag = 0
            }
            let contactInfoItem = ContactInfoItem(type: tagController.tags[currentTag], value: "")
            sectionItems.append(contactInfoItem)
            
            //tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            tableView.insertRows(at: [IndexPath(row: sectionItems.count - 1, section: indexPath.section)], with: .automatic)
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
        return sectionNames.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        
        guard let _ = contactInfo else { return 1 }
        
        let sectionItems = getArrayPerSection(section)
        return sectionItems.count
    }
    
    func getArrayPerSection(_ section: Int) -> [ContactInfoItem] {
        if contactInfo == nil {
            return []
        }
        
        switch section {
        case 1:
            return contactInfo!.phoneNumbers
        case 2:
            return contactInfo!.emails
        case 5:
            return contactInfo!.urls
        case 6:
            return contactInfo!.addresses
        case 7:
            return contactInfo!.birthdays
        case 8:
            return contactInfo!.dates
        default:
            return []
        }
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
        print(indexPath)
        
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
            return cell
        case 3, 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelWithButtonCell", for: indexPath) as! ButtonCell
            cell.txtLabel?.text = addButtonLabel
            cell.accessoryType = .disclosureIndicator
            return cell
        case 12:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath)
            return cell
        default:
            let sectionItems = getArrayPerSection(indexPath.section)
            print(sectionItems.count)
            if sectionItems.count == indexPath.row {
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

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contactInfo" {
            let viewController = segue.destination as! TagsViewController
            let button = sender as! UIButton
            viewController.button = button
//            cell.textLabel?.text = viewController.contactName
        }
    }
}
