//
//  ReusableNumpad.swift
//  Recents
//
//  Created by Dimitar Dinev on 4.05.21.
//

import UIKit

//rename
class ReusableNumpad: UIControl {
    
    var keyPressed: String!
    
    @IBAction func numPressed(_ sender: UIButton) {
        changeNumbersBackground(sender)
        keyPressed = sender.titleLabel?.text
        sendActions(for: .allEvents)
        print("numPressed")
    }
    
    func changeNumbersBackground(_ sender: UIButton) {
        UIView.animate(withDuration: 1) {
            sender.backgroundColor = .systemGray2
            sender.backgroundColor = UIColor(hex: "E8E7E8FF")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let viewFromXib = Bundle.main.loadNibNamed("ReusableNumpad", owner: self, options: nil)?.first as! ReusableNumpad
        viewFromXib.frame = frame
        addSubview(viewFromXib)
        print("frame")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("required")
    }
}
