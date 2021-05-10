//
//  NumPadView.swift
//  Recents
//
//  Created by Dimitar Dinev on 4.05.21.
//

import UIKit

class NumPadView: UIView {
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var addNumberButton: UIButton!
    
    var countryCodes = ["1", "365", "44"]
    
    func needSpace(_ text: String) -> Bool {
        let first = text.first
        return first == "0" && text.count == 3 ||
            first == "+" && countryCodes.contains(text) ||
            first != "0" && first != "+" && text.count == 2
    }
    
    @IBAction func numPressed(_ sender: UIButton) {
        if needSpace(numberLabel.text!) {
            numberLabel.text?.append(" ")
        }
        
        numberLabel.text?.append(sender.currentTitle ?? "")
        if numberLabel.text?.count != 0 {
            addNumberButton.isHidden = false
        }
        changeNumbersBackground(sender)
    }
    
    @IBAction func deleteNumber(_ sender: Any) {
        if numberLabel.text!.count == 0 {
            addNumberButton.isHidden = true
            return
        }
        numberLabel.text?.removeLast()
    }
    
    func changeNumbersBackground(_ sender: UIButton) {
        UIView.animate(withDuration: 1) {
            sender.backgroundColor = .systemGray2
            sender.backgroundColor = UIColor(hex: "E8E7E8FF")
        }
    }
    
    @IBAction func longPressZero(_ sender: Any) {
        numberLabel.text?.append("+")
    }
}
