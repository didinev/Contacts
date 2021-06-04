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
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = tags[indexPath.row]
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        
//        
//        cell.accessoryType = tags.firstIndex(of: indexPath.row) != nil ? .checkmark : .none
//    }
}
