//
//  CallViewController.swift
//  Recents
//
//  Created by Dimitar Dinev on 23.04.21.
//

import UIKit

class CallViewController: UIViewController {
    
    @IBOutlet var callLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    var call: String!
    
    @IBOutlet var hideButton: UIButton!
    @IBOutlet var numberLabel: UILabel!
    
    let reusableKeypad = ReusableNumpad(frame: CGRect(x: 45, y: 20, width: 290.0, height: 575))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(reusableKeypad)
        reusableKeypad.isHidden = true
        hideButton.isEnabled = false
        hideButton.setTitle("", for: .disabled)
    }
    
    @IBAction func openKeypad(_ sender: Any) {
        reusableKeypad.isHidden = false
        hideButton.isEnabled = true
    }
    
    @IBOutlet var numpad: ReusableNumpad!
    
    @IBAction func hideKeypad(_ sender: Any) {
        reusableKeypad.isHidden = true
        hideButton.isEnabled = false
    }
    
    var timer = Timer()
    var seconds = 0
    var minutes = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        callLabel.text = call
        runTimer()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        seconds += 1
        if seconds == 60 {
            seconds = 0
            minutes += 1
        }
        timerLabel.text = seconds < 10 ? "Mobile 0\(minutes):0\(seconds)" : "Mobile 0\(minutes):\(seconds)"        
    }
    
    @IBAction func endCall(_ sender: Any) {
        do {
            let recentStore = RecentStore()
            recentStore.allCalls.insert(Call(name: callLabel.text!, typeOfCall: "Dial", date: Date(), isMissed: false, isOutgoing: true), at: 0)
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(RecentStore.formatter)
            let JsonData = try encoder.encode(recentStore.allCalls)
            try JsonData.write(to: recentStore.callsArchiveURL)
        } catch {
            print(error)
        }
        
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func numPressed(_ sender: UIButton) {
        if numberLabel.text?.first == "0" {
            if numberLabel.text?.count == 3 {
                numberLabel.text?.append(" ")
            }
        } else if numberLabel.text?.count == 2 {
            numberLabel.text?.append(" ")
        }
        
        numberLabel.text?.append(sender.currentTitle!)
    }
}
