//
//  CellType.swift
//  Recents
//
//  Created by Dimitar Dinev on 4.06.21.
//

import UIKit

class InfoTextLabel: UITableViewCell {
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var isRecentLabel: UILabel!
    @IBOutlet var isFavouriteImg: UIImageView!
    @IBOutlet var favouriteToRecentConstraint: NSLayoutConstraint!
}

class TextFieldCell: UITableViewCell {
    @IBOutlet var textField: CustomTextField!
}

class LabelCell: UITableViewCell {
    @IBOutlet var txtLabel: UILabel!
    @IBOutlet var textField: CustomTextField!

}

//class TypeValueCell: UITableViewCell, ContactCell {
//    @IBOutlet var name: UILabel!
//    @IBOutlet var number: UILabel!
//    @IBOutlet var isRecentLabel: UILabel!
//    @IBOutlet var isFavouriteImage: UIImageView!
//    @IBOutlet var favouriteToRecentConstraint: NSLayoutConstraint!
//    
//    var isMissed = false
//    var isFavourite = false
//    var isRecent = false
//    
//    func setup(_ item: (String, String)) {
//        name.text = item.0
//        number.text = item.1
//        //name.textColor = isMissed ? .red : .black
//        number.textColor = isMissed ? .red : .link
//        
//        isFavouriteImage.isHidden = !isFavourite
//        isRecentLabel.isHidden = !isRecent
//        favouriteToRecentConstraint.constant = isFavourite ? 5 : -isFavouriteImage.bounds.width
//    }
//}

class ButtonCell: UITableViewCell {
    @IBOutlet var txtLabel: UILabel!
}

class AddCell: UITableViewCell {
    @IBOutlet var txtLabel: UILabel!
}

class CustomTextField: UITextField {
    var indexPath = IndexPath()
}

class DeleteCell: UITableViewCell {
    @IBOutlet var btn: UIButton!
}

class FavouriteCell: UITableViewCell {
    @IBOutlet var initialsLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneTypeLabel: UILabel!
}

class AddToFavouritesCell: UITableViewCell {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var addType: UILabel!
}

class DataCell: UITableViewCell {
    @IBOutlet var addType: UILabel!
    @IBOutlet var value: UILabel!
}
