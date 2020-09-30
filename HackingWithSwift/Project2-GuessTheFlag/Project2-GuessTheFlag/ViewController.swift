//
//  ViewController.swift
//  Project2-GuessTheFlag
//
//  Created by Alexander Karaatanasov on 18.04.19.
//  Copyright © 2019 Alexander Karaatanasov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Vars
    
    var countries = [String]()
    
    var answeredQuestionsCount = 0
    var correctAnswer = 0
    var score = 0 {
        didSet {
            scoreBarButtonItem.title = "Score: \(score)"
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var firstFlag: UIButton!
    @IBOutlet weak var secondFlag: UIButton!
    @IBOutlet weak var thirdFlag: UIButton!
    @IBOutlet weak var scoreBarButtonItem: UIBarButtonItem!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateCountries()
        setupUI()
        askQuestion()
    }
    
    // MARK: - Private
    
    private func populateCountries() {
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    }
    
    private func setupUI() {
        firstFlag.layer.borderWidth = 1
        secondFlag.layer.borderWidth = 1
        thirdFlag.layer.borderWidth = 1
        
        firstFlag.layer.borderColor = UIColor.lightGray.cgColor
        secondFlag.layer.borderColor = UIColor.lightGray.cgColor
        thirdFlag.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func askQuestion() {
        countries.shuffle()
        setButtonImages()
        correctAnswer = Int.random(in: 0...2)
        title = countries[correctAnswer].uppercased()
    }
    
    private func setButtonImages() {
        firstFlag.setImage(UIImage(named: countries[0]), for: .normal)
        secondFlag.setImage(UIImage(named: countries[1]), for: .normal)
        thirdFlag.setImage(UIImage(named: countries[2]), for: .normal)
    }
    
    private func resetGame() {
        answeredQuestionsCount = 0
        score = 0
        askQuestion()
    }
    
    private func checkAnswer(from sender: UIButton) {
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
    
    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    // MARK: - IBActions
    
    @IBAction private func buttonTapped(_ sender: UIButton) {
        checkAnswer(from: sender)
    }
    
}
