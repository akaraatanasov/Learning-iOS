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
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var scoreBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateCountries()
        setupUI()
        askQuestion()
    }
    
    func populateCountries() {
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    }
    
    func setupUI() {
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
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
    
    @IBAction func buttonTapped(_ sender: UIButton) {
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
