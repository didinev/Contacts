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
    
    var timer = Timer()
    var seconds = 0
    var minutes = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        callLabel.text = call
        runTimer()
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
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
        self.dismiss(animated: false, completion: nil)
    }
}
