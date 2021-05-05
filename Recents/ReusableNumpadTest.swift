//
//  ReusableNumpad.swift
//  Recents
//
//  Created by Dimitar Dinev on 4.05.21.
//

import UIKit

@IBDesignable
class ReusableNumpadTest: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
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
    
    func changeNumbersBackground(_ sender: UIButton) {
        UIView.animate(withDuration: 1) {
            sender.backgroundColor = .systemGray2
            sender.backgroundColor = UIColor(hex: "E8E7E8FF")
        }
    }
//    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let view = Bundle.main.loadNibNamed("ReusableNumpad", owner: self, options: nil)![0] as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func configureView() {
        guard let view = self.loadViewFromNib(nibName: "ReusableNumpad") else {
            return
        }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func loadViewFromNib(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }

}


