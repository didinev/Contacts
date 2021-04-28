//
//  DialViewController.swift
//  Recents
//
//  Created by Dimitar Dinev on 23.04.21.
//

import UIKit

class DialViewController: UIViewController {
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var addNumberButton: UIButton!
    
    var countryCodes = ["1", "365", "44"]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromDial" {
            let callViewController = segue.destination as! CallViewController
            callViewController.call = numberLabel.text
        }
    }
    
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

extension UIColor {
    convenience init(rgb: Int) {
        let components = (
            R: CGFloat((rgb >> 16) & 0xff) / 255,
            G: CGFloat((rgb >> 08) & 0xff) / 255,
            B: CGFloat((rgb >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    
    convenience init(hex: String) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 1

        let scanner = Scanner(string: hex)
        var hexNumber: UInt64 = 0

        if scanner.scanHexInt64(&hexNumber) {
            if hex.count == 8 {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
            }
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
