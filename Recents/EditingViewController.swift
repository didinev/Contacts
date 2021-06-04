//
//  EditingViewController.swift
//  Recents
//
//  Created by Dimitar Dinev on 1.06.21.
//

import UIKit

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
//        let viewController = ContactInfoViewController()
//        viewController.contactName = self.name
//        self.navigationController?.popViewController(animated: true)
    }
    
    var name: String!
    var phoneNumbers: [(String, String)]!
    
    var sectionRows = [
        ["First Name", "Last Name", "Company"],
        ["home", "add phone"],
        ["add email"],
        ["Ringtone"],
        ["Text Tone"],
        ["add url"],
        ["add address"],
        ["add birthday"],
        ["add date"],
        ["add related name"],
        ["add social profile"],
        ["add instant message"],
        ["Notes"],
        ["add field"],
        ["link contacts..."],
        ["Delete Contact"],
    ]
    
    let tag = TagsViewController()
    var currentTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstLetterLabel.text = "\(name.first!)"
        tableView.setEditing(true, animated: false)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            sectionRows[indexPath.section].remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        if editingStyle == .insert {
            let firstIndexPath = IndexPath(row: 0, section: indexPath.section)
            
            currentTag = currentTag + 1
            if currentTag >= tag.tags.count {
                currentTag = 0
            }
            sectionRows[indexPath.section].insert(tag.tags[currentTag], at: 0)
            tableView.insertRows(at: [firstIndexPath], with: .automatic)
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
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UIView()
        label.backgroundColor = .systemGray6
        return label
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UIView()
        label.backgroundColor = .systemGray6
        return label
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionName = sectionRows[indexPath.section][indexPath.row]
        
        switch sectionName {
        case "Ringtone", "Text Tone":
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelWithButtonCell", for: indexPath) as! ButtonCell
            cell.txtLabel?.text = sectionName
            cell.accessoryType = .disclosureIndicator
            return cell
        case "First Name", "Last Name", "Company":
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
            cell.textField.placeholder = sectionName
            if sectionName == "First Name" {
                cell.textField.text = name
            }
            return cell
        case "Notes":
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextViewCell", for: indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCells", for: indexPath) as! LabelCell
            cell.txtLabel.text = sectionName
            cell.txtLabel.textColor = cell.txtLabel?.text == "Delete Contact" ? .systemRed : .systemBlue
            
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contactInfo" {
            let viewController = segue.destination as! ContactInfoViewController
            let cell = sender as! UITableViewCell
            cell.textLabel?.text = viewController.contactName
        }
    }
}

class TextFieldCell: UITableViewCell {
    @IBOutlet var textField: UITextField!
}

class LabelCell: UITableViewCell {
    @IBOutlet var txtLabel: UILabel!
}

class ButtonCell: UITableViewCell {
    @IBOutlet var txtLabel: UILabel!
}
