//
//  TagsViewController.swift
//  Recents
//
//  Created by Dimitar Dinev on 2.06.21.
//

import UIKit

class TagsViewController: UITableViewController {
    let tags = [
        "mobile",
        "home",
        "work",
        "school",
        "iPhone",
        "Apple Watch",
    ]
    
    var currentLabel: String!
    var button: UIButton!
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basic", for: indexPath) as! TagCell
        cell.textLabel?.text = tags[indexPath.row]
        cell.checkedImage.isHidden = currentLabel != tags[indexPath.row]
        return cell
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
//        cell.textLabel?.text = tags[indexPath.row]
//
//        return cell
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.accessoryType = button.currentTitle == tags[indexPath.row] ? .checkmark : .none
//    }
}

class TagCell: UITableViewCell {
    @IBOutlet var checkedImage: UIImageView!
}
