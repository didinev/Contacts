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
    
    var timer = Timer()
    var seconds = 00
    var minutes = 0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        timerLabel.text = "Facetime \(minutes):\(seconds)"
    }
}
