import UIKit

class CallViewController: UIViewController {
    var dialController = DialViewController()
    @IBOutlet var callLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    var call: String!
    @IBOutlet var detailsView: UIView!
    @IBOutlet var buttonsStackView: UIStackView!
    @IBOutlet var hideButton: UIButton!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var numpad: KeypadContainerViewContol!
    
    var phoneNumber: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //dialController.isDialController = false
        numpad.addTarget(self, action: #selector(keyEvent), for: .allEvents)
        numpad.isHidden = true
        numpad.style = .call
        hideButton.isEnabled = false
        hideButton.setTitle("", for: .disabled)
        numberLabel.text = phoneNumber
    }
    
    @objc func keyEvent(_ sender: KeypadContainerViewContol) {
        numberLabel.text! += sender.keyPressed
    }
    
    @IBAction func openKeypad(_ sender: Any) {
        numberLabel.isHidden = false
        detailsView.isHidden = true
        buttonsStackView.isHidden = true
        numpad.isHidden = false
        hideButton.isEnabled = true
    }
    
    @IBAction func hideKeypad(_ sender: Any) {
        numberLabel.isHidden = true
        detailsView.isHidden = false
        buttonsStackView.isHidden = false
        numpad.isHidden = true
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
//        do {
//            let recentStore = RecentStore()
//            recentStore.allCalls.insert(RecentCall(name: callLabel.text!, typeOfCall: "Dial", date: Date(), isMissed: false, isOutgoing: true), at: 0)
//            let encoder = JSONEncoder()
//            encoder.dateEncodingStrategy = .formatted(RecentStore.formatter)
//            let JsonData = try encoder.encode(recentStore.allCalls)
//            try JsonData.write(to: recentStore.callsArchiveURL)
//        } catch {
//            print(error)
//        }
        
        self.dismiss(animated: false, completion: nil)
    }
}
