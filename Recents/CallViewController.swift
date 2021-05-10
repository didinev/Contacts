import UIKit

class CallViewController: UIViewController {
    
    @IBOutlet var callLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    var call: String!
    
    @IBOutlet var hideButton: UIButton!
    @IBOutlet var numberLabel: UILabel!
    
    let reusableKeypad: ReusableNumpad = .fromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reusableKeypad.addTarget(self, action: #selector(keyEvent), for: .allEvents)
        self.view.addSubview(reusableKeypad)
        reusableKeypad.isHidden = true
        hideButton.isEnabled = false
        hideButton.setTitle("", for: .disabled)
        
        reusableKeypad.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            reusableKeypad.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 120),
            reusableKeypad.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            reusableKeypad.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reusableKeypad.heightAnchor.constraint(equalToConstant: 375)
        ])
    }
    
    @objc func keyEvent(_ sender: ReusableNumpad) {
        numberLabel.text! += sender.keyPressed
    }
    
    @IBAction func openKeypad(_ sender: Any) {
        reusableKeypad.isHidden = false
        hideButton.isEnabled = true
    }
    
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
}
