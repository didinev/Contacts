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
    
    var sectionRows = [
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
    
    var sections: [String: [(String, String)]] = [
        "add phone": [],
        "add email": [],
        "add url": [],
        "add address": [],
        "add date": [],
        "add birthday": [],
        "add related name": [],
        "add social profile": [],
        "add instant message": []
    ]
    
    let tagController = TagsViewController()
    var currentTag = 1
    var isInitialCell = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactInfo?.phoneNumbers.forEach { sections["phone"]?.append(($0.type, $0.number))}
        contactInfo?.emails.forEach { sections["email"]?.append(($0.type, $0.email))}
        contactInfo?.urls.forEach { sections["url"]?.append(($0.type, $0.url))}
        contactInfo?.addresses.forEach { sections["address"]?.append(($0.type, $0.address))}
        contactInfo?.dates.forEach { sections["date"]?.append(($0.type, $0.date))}
        contactInfo?.birthdays.forEach { sections["birthday"]?.append(($0.type, $0.date))}
        
        firstLetterLabel.text = "\(contact.firstName!.first!)"
        tableView.setEditing(true, animated: false)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            let commit = sectionRows[indexPath.row]
////            self.viewContext.delete(commit)
//            sectionRows.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
            
//            saveContext()
            
            sections[sectionRows[indexPath.section]]?.remove(at: indexPath.row)
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
//            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        if editingStyle == .insert {
            currentTag = currentTag + 1
            if currentTag >= tagController.tags.count {
                currentTag = 0
            }
            sections[sectionRows[indexPath.section]]?.insert((tagController.tags.first!, "nil"), at: indexPath.row)
            tableView.insertRows(at: [IndexPath(row: sections[sectionRows[indexPath.section]]!.count - 1, section: indexPath.section)], with: .automatic)
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
        return sectionRows.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionRows[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 12 ? 150 : 50
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 17.5
//    }
    
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 25
//    }
    
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
        let sectionName = sectionRows[indexPath.section]
        
        switch sectionName {
        case "First Name", "Last Name", "Company":
            print("dhsa")
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
            cell.textField.placeholder = sectionName
//            if sectionName == "First Name" {
//                cell.textField.text = contact.firstName
//            }
            
            switch indexPath.row {
            case 0:
                cell.textField.text = contact.firstName
            case 1:
                cell.textField.text = contact.lastName
            default:
                cell.textField.text = contact.companyName
            }
            return cell
        case "Ringtone", "Text Tone":
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelWithButtonCell", for: indexPath) as! ButtonCell
            cell.txtLabel?.text = sectionName
            cell.accessoryType = .disclosureIndicator
            return cell
        case "Notes":
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath)
            return cell
        case "add phone", "add email", "add url", "add address", "add birthday", "add date", "add related name", "add social profile", "add instant message", "add field", "link contacts...", "Delete Contact":
            let label = sectionRows[indexPath.section]
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCells", for: indexPath) as! AddCell
            //            cell.txtLabel.text = sections[sectionName]?[indexPath.row].0
            cell.txtLabel.text = sections[label]?[indexPath.row].0
            cell.txtLabel.textColor = cell.txtLabel?.text == "Delete Contact" ? .systemRed : .systemBlue
            return cell
        default:
            let label = sectionRows[indexPath.section]
            
//            if indexPath.row == sections[label]?.count || indexPath.section == 13 || indexPath.section == 14 {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "AddCells", for: indexPath) as! AddCell
//                //            cell.txtLabel.text = sections[sectionName]?[indexPath.row].0
//                cell.txtLabel.text = label
//                cell.txtLabel.textColor = cell.txtLabel?.text == "Delete Contact" ? .systemRed : .systemBlue
//                return cell
//            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCells", for: indexPath) as! LabelCell
                cell.txtLabel.text = sections[label]?[indexPath.row].1
    //            cell.txtLabel.text = sectionName
                cell.textField.increaseSize(cell.txtLabel)

                let gradient = CAGradientLayer()
                gradient.colors = [UIColor.white.cgColor, UIColor.systemGray2.cgColor]
                gradient.frame = CGRect(x: -5, y: 0, width: 1, height: cell.bounds.height)
                cell.textField.layer.addSublayer(gradient)

                if !isInitialCell {
                    cell.textField.becomeFirstResponder()
                }
                
                return cell
            //}
            
            
            
//            if let text = sections[sectionName]?[indexPath.row].0 {
//                print(text)
//            }
//            print(sections[label]?[indexPath.row].1)
            
        }
        
//        switch sectionName {
//        case "Ringtone", "Text Tone":
//            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelWithButtonCell", for: indexPath) as! ButtonCell
//            cell.txtLabel?.text = sectionName
//            cell.accessoryType = .disclosureIndicator
//            return cell
//        case "First Name", "Last Name", "Company":
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
//            cell.textField.placeholder = sectionName
//
//            switch sectionName {
//            case "First Name":
//                cell.textField.text = contact.firstName
//            case "Last Name":
//                cell.textField.text = contact.lastName
//            default:
//                cell.textField.text = contact.companyName
//            }
//            return cell
//        case "Notes":
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath)
//            return cell
//        case "add phone", "add email", "add url", "add address", "add birthday", "add date", "add related name", "add social profile", "add instant message", "add field", "link contacts...", "Delete Contact":
//            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCells", for: indexPath) as! AddCell
////            cell.txtLabel.text = sections[sectionName]?[indexPath.row].0
//            cell.txtLabel.text = sectionName
//            cell.txtLabel.textColor = cell.txtLabel?.text == "Delete Contact" ? .systemRed : .systemBlue
//            return cell
//        default:
//            let label = sectionRows[indexPath.section][indexPath.row]
//            if let text = sections[sectionName]?[indexPath.row].0 {
//                print(text)
//            }
////            print(sections[label]?[indexPath.row].1)
//            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCells", for: indexPath) as! LabelCell
//            cell.txtLabel.text = sections[label]?[indexPath.row].1
////            cell.txtLabel.text = sectionName
//            cell.textField.increaseSize(cell.txtLabel)
//
//            let gradient = CAGradientLayer()
//            gradient.colors = [UIColor.white.cgColor, UIColor.systemGray2.cgColor]
//            gradient.frame = CGRect(x: -5, y: 0, width: 1, height: cell.bounds.height)
//            cell.textField.layer.addSublayer(gradient)
//
//            if !isInitialCell {
//                cell.textField.becomeFirstResponder()
//            }
//
//            return cell
//        }
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


