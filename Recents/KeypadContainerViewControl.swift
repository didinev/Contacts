//
// KeypadContainerViewControl.swift
//  Recents
//
//  Created by Dimitar Dinev on 10.05.21.
//

import UIKit

enum KeypadStyle {
    case dial, call
}

class KeypadContainerViewContol: UIControl, UICollectionViewDataSource {
    var dialController = DialViewController()
//    var isDialController = dialController.contains(dialController.numpad)
    var style: KeypadStyle = .dial
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCollectionView()
    }
    
    private var buttons: [ButtonView] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        buttons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath)
        cell.backgroundView = buttons[indexPath.row]
        return cell
    }
    
    var keyPressed = ""
    
    func initCollectionView() {
        let letters = [
            ("1",""),
            ("2","A B C"),
            ("3","D E F"),
            ("4","G H I"),
            ("5","J K L"),
            ("6","M N O"),
            ("7","P Q R S"),
            ("8","T U V"),
            ("9","W X Y Z"),
            ("*",""),
            ("0","+"),
            ("#","")
        ]
        
        //self.window?.rootViewController is DialViewController
        
        buttons = letters.map {
            let button = ButtonView()
            button.createButton(letters: $0)
            if style == .dial && button.numberLabel.text == "0" {
                print("Current style \(style)")
                let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressZero))
                button.button.addGestureRecognizer(gestureRecognizer)
            }
            button.button.addTarget(self, action: #selector(keyEvent), for: .touchUpInside)
            return button
        }
        
        let size = frame.width / 3 - 30
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.itemSize = CGSize(width: size, height: size)
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: collectionViewLayout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "MyCell")
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        collectionView.dataSource = self
    }
    
    var longPressZeroFlag = true
    
    @objc func longPressZero(_ sender: UIButton) {
        longPressZeroFlag.toggle()
        if longPressZeroFlag {
            return
        }
        
        keyPressed = "+"
        sendActions(for: .touchDown)
    }
    
    @objc func keyEvent(_ sender: UIButton) {
        changeNumbersBackground(sender)
        keyPressed = sender.accessibilityLabel!
        sendActions(for: .touchDown)
    }
    
    func changeNumbersBackground(_ sender: UIButton) {
        UIView.animate(withDuration: 1) {
            sender.backgroundColor = .systemGray2
            sender.backgroundColor = UIColor(hex: "E8E7E8FF")
        }
    }
}

class ButtonView: UIView {
    let button = UIButton()
    var numberLabel = UILabel()
    var charactersLabel = UILabel()
    
    override func layoutSubviews() {
        layer.cornerRadius = bounds.width * 0.5
        clipsToBounds = true
    }
    
    func createButton(letters: (number: String, character: String)) {
        numberLabel.text = letters.number
        charactersLabel.text = letters.character
        button.accessibilityLabel = letters.number
        setButtonConstraints()
    }
    
    func setButtonConstraints() {
        backgroundColor = UIColor(hex: "E8E7E8FF")
        
        addSubview(button)
        addSubview(numberLabel)
        addSubview(charactersLabel)
        
        numberLabel.font = UIFont.systemFont(ofSize: 30)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        
        charactersLabel.font = UIFont.systemFont(ofSize: 10)
        charactersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10),
            numberLabel.bottomAnchor.constraint(equalTo: charactersLabel.topAnchor),
            charactersLabel.centerXAnchor.constraint(equalTo: centerXAnchor)            
        ])
    }
}
