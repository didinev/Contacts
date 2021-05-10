//
//  ReusableNumpad.swift
//  Recents
//
//  Created by Dimitar Dinev on 4.05.21.
//

import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

//rename
class ReusableNumpad: UIControl, UICollectionViewDelegate {
    var keyPressed: String!
    
    @IBAction func numPressed(_ sender: UIButton) {
        changeNumbersBackground(sender)
        keyPressed = sender.titleLabel?.text
        sendActions(for: .touchDown)
    }
    
    func changeNumbersBackground(_ sender: UIButton) {
        UIView.animate(withDuration: 1) {
            sender.backgroundColor = .systemGray2
            sender.backgroundColor = UIColor(hex: "E8E7E8FF")
        }
    }
}
