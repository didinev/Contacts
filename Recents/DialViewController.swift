//
//  DialViewController.swift
//  Recents
//
//  Created by Dimitar Dinev on 23.04.21.
//

import UIKit

class DialViewController: UIViewController {
    var runningNumber = ""
    @IBOutlet var label: UILabel!
    
    var grayOperatorInitialBackground = "A5A5A5FF"
    var orangeOperatorInitialBackground = "F1A33CFF"
    var equalButtonClicked = "F1A33C08"
    
    var item: UILabel! {
        didSet {
            label.text = runningNumber
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromDial" {
            let callViewController = segue.destination as! CallViewController
            callViewController.callLabel = item
        }
    }
    
    @IBAction func numPressed(_ sender: UIButton) {
        runningNumber += "\(sender.tag)"
        label.text = runningNumber
        changeNumbersBackground(sender)
    }
    
    func changeNumbersBackground(_ sender: UIButton) {
        UIView.animate(withDuration: 1) {
            sender.backgroundColor = UIColor(rgb: 0x333333)
            sender.backgroundColor = UIColor(hex: self.grayOperatorInitialBackground)
        }
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
