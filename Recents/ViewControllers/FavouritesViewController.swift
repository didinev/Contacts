//
//  FavouritesViewController.swift
//  Recents
//
//  Created by Dimitar Dinev on 15.06.21.
//

import UIKit

class FavouritesViewController: UITableViewController {
    var favouritesStore = FavouritesStore.shared
    var contact: Contact?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favouritesStore.allFavourites.count == 0 ? setEmptyMessage("No Favourites") : restore()
        
        return favouritesStore.allFavourites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath) as! FavouriteCell
        let currentCell = favouritesStore.allFavourites[indexPath.row]
        cell.nameLabel.text = currentCell.contact?.firstName
        cell.initialsLabel.text = String(currentCell.contact?.firstName!.first! ?? "n")
        cell.phoneTypeLabel.text = currentCell.label
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        favouritesStore.move(fromIndex: sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        favouritesStore.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        contact = favouritesStore.allFavourites[indexPath.row].contact
        performSegue(withIdentifier: "showContactFromFavourites", sender: (Any).self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showContactFromFavourites":
            let contactViewController = segue.destination as! ContactInfoViewController
            contactViewController.contact = contact
            contactViewController.contactInfo = ContactInfo()
        case "callContactFromFavourites":
            let callingController = segue.destination as! CallViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let contact = favouritesStore.allFavourites[indexPath.row].contact!
            let firstName = contact.firstName!
            let lastName = contact.lastName ?? ""
            callingController.phoneNumber = firstName + lastName
            let name = firstName + lastName
            let type = favouritesStore.allFavourites[indexPath.row].label
            
            RecentStore.shared.addCall(name, type!)
        case "showAllContactsFromFavourites":
            let navController = segue.destination as? UINavigationController
            let contactsController = navController?.topViewController as? ContactsViewController
            contactsController?.isFromFavourite = true
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "callContactFromFavourites", sender: (Any).self)
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        messageLabel.text = message
        messageLabel.textAlignment = .center

        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }

    func restore() {
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
    }
}











//    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        contact = favouritesStore.allFavourites[indexPath.row].contact
//        performSegue(withIdentifier: "showContactFromFavourites", sender: self)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showContactFromFavourites" {
//            let contactController = segue.destination as! ContactsViewController
//            let indexPath = tableView.indexPathForSelectedRow
//            contactController.contactStore.getContact(indexPath!) = contact
////            contactController.contact = contact
//        }
//    }
