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
}

class TextFieldCell: UITableViewCell {
    @IBOutlet var textField: UITextField!
}

class LabelCell: UITableViewCell {
    @IBOutlet var txtLabel: UILabel!
    @IBOutlet var textField: UITextField!
}

class ButtonCell: UITableViewCell {
    @IBOutlet var txtLabel: UILabel!
}

class AddCell: UITableViewCell {
    @IBOutlet var txtLabel: UILabel!
    
}
