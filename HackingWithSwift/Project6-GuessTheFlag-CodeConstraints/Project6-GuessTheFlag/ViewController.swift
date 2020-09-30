//
//  ViewController.swift
//  Project6-GuessTheFlag
//
//  Created by Alexander Karaatanasov on 18.04.19.
//  Copyright © 2019 Alexander Karaatanasov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var countries = [String]()
    
    var answeredQuestionsCount = 0
    var correctAnswer = 0
    var score = 0 {
        didSet {
            scoreBarButtonItem.title = "Score: \(score)"
        }
    }
    
    var button1 = UIButton()
    var button2 = UIButton()
    var button3 = UIButton()
    
    @IBOutlet weak var scoreBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateCountries()
        setupUI()
        addConstraints()
        askQuestion()
    }
    
    func populateCountries() {
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    }
    
    func setupUI() {
        var tag = 0;
        for button in [button1, button2, button3] {
            button.tag = tag
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.borderWidth = 1
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            view.addSubview(button)
            tag += 1
        }
    }

    func addConstraints() {
        NSLayoutConstraint(item: button1, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: button1, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1, constant: 12).isActive = true
        NSLayoutConstraint(item: button1, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: button1, attribute: .height, relatedBy: .equal, toItem: button1, attribute: .width, multiplier: 1.0 / 2.0, constant: 0).isActive = true
        
        NSLayoutConstraint(item: button2, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: button2, attribute: .top, relatedBy: .equal, toItem: button1, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: button2, attribute: .height, relatedBy: .equal, toItem: button1, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: button2, attribute: .height, relatedBy: .equal, toItem: button2, attribute: .width, multiplier: 1.0 / 2.0, constant: 0).isActive = true

        NSLayoutConstraint(item: button3, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: button3, attribute: .top, relatedBy: .equal, toItem: button2, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: button3, attribute: .height, relatedBy: .equal, toItem: button2, attribute: .height, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: button3, attribute: .height, relatedBy: .equal, toItem: button3, attribute: .width, multiplier: 1.0 / 2.0, constant: 0).isActive = true
        NSLayoutConstraint(item: button3, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: view, attribute: .bottom, multiplier: 1, constant: -20).isActive = true
    }
    
    func askQuestion() {
        countries.shuffle()
        setButtonImages()
        correctAnswer = Int.random(in: 0...2)
        title = countries[correctAnswer].uppercased()
    }
    
    func setButtonImages() {
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }
    
    func resetGame() {
        answeredQuestionsCount = 0
        score = 0
        askQuestion()
    }
    
    func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        answeredQuestionsCount += 1
        
        if sender.tag == correctAnswer {
            score += 1
        } else {
            score -= 1
            showAlert(title: "Wrong", message: "That's the flag of \(countries[sender.tag].uppercased()).")
        }
        
        if answeredQuestionsCount == 10 {
            showAlert(title: "Game over", message: "Your final score is \(score).")
            resetGame()
        } else {
            askQuestion()
        }
    }
    
}
