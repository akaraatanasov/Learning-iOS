//
//  ViewController.swift
//  Set
//
//  Created by Alexander on 17.01.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

// MARK: - Bugs to fix
// 1. When game finished and New Game (in alert) is pressed - game crashes
// 2. When score is more than 100 there are ...

import UIKit

class ViewController: UIViewController {
    // MARK: - Vars
    
    private var timer: Timer!
    private var game = Set()
    private var currentlyShownCards = Constants.shownCards / 2 {
        didSet {
            updateViewFromModel()
        }
    }

    private var cardsLeftCount = Constants.initialCardsLeft {
        didSet {
            updateCardsLeftCountLabel()
        }
    }
    
    private var scoreCount = 0 {
        didSet {
            updateScoreCountLabel()
        }
    }
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var cardsLeftLabel: UILabel! {
        didSet {
            updateCardsLeftCountLabel()
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel! {
        didSet {
            updateScoreCountLabel()
        }
    }
    
    @IBOutlet weak var setView: SetView!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    // MARK: - @IBActions
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            
            let card = game.shownCards[cardNumber]
            addBorder(to: sender, from: card)
            if game.selectedCards.count == Constants.maximumSelectedCards {
                updateViewFromModel()
            }
            // or use updateOneCard(at: cardNumber)
            
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    @IBAction private func newGameButton(_ sender: UIButton) {
        // These strings should be localized.
        let alert = UIAlertController(title: "Are you sure?", message: "You will lose your current points and will start a new game", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            self?.startNewGame()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            NSLog("The No alert occured.")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func dealCardsButton(_ sender: UIButton) {
        if cardsLeftCount >= Constants.maximumSelectedCards {
            // currentlyShownCards += Constants.maximumSelectedCards
            // cardsLeftCount -= Constants.maximumSelectedCards
            
            setView.dealCards()
        } else {
            // These too
            let alert = UIAlertController(title: "No more space left", message: "You can't have more than 24 cards", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:
                { _ in NSLog("The OK button was pressed.") }))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Funcs
    
    override func viewDidLoad() {
//        updateViewFromModel()
    }
    
    // Labels
    private func updateCardsLeftCountLabel() {
        let attributes: [NSAttributedStringKey : Any] = [
            .foregroundColor : UIColor.black.withAlphaComponent(1.0)
        ]
        let attributedString = NSAttributedString(string: "Cards left: \(cardsLeftCount)", attributes: attributes)
        cardsLeftLabel.attributedText = attributedString
    }
    
    private func updateScoreCountLabel() {
        let attributes: [NSAttributedStringKey : Any] = [
            .foregroundColor : UIColor.black
        ]
        let attributedString = NSAttributedString(string: "Score: \(scoreCount)", attributes: attributes)
        scoreLabel.attributedText = attributedString
    }
    
    // Buttons
    private func updateViewFromModel() {
        updateCardView()
        
        if game.selectedCards.count == Constants.maximumSelectedCards {
            removeSelectedCardsAndBorder()
            
            if game.thereIsSet {
                scoreCount += 5
                if cardsLeftCount >= 3 {
                   cardsLeftCount -= 3
                }
            } else {
                if scoreCount >= 2 {
                    scoreCount -= 2
                }
                updateCardView()
            }
        }
    }
    
    private func updateCardView() {
        let deck = game.shownDeck
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.shownCards[index]
            
            // H: Can you try to refactor this one? Something like enum for the borderColor.
            // A: Done
            button.layer.cornerRadius = CGFloat(Constants.cornerRadius)
            if index < currentlyShownCards {
                if button.isEnabled == false || button.isHidden == true {
                    button.isEnabled = true
                    button.isHidden = false
                    button.backgroundColor = UIColor.white
                }
                
                let currentString = valueToString(cardValue: deck[card]!)
                button.setAttributedTitle(currentString, for: .normal)
                addBorder(to: button, from: card)

            } else {
                button.isHidden = true
                button.isEnabled = false
            }
        }
    }
    
    private func updateOneCard(at index: Int) { // Currently this func is redundant
        assert(game.shownCards.indices.contains(index), "ViewController.updateOneCard(at: \(index)): chosen index not in the cards")
        
        let button = cardButtons[index]
        let card = game.shownCards[index]
        addBorder(to: button, from: card)
        
        if game.selectedCards.count == Constants.maximumSelectedCards {
            updateViewFromModel()
        }
    }
    
    // MARK: - Helper methods
    
    private func valueToString(cardValue currentCard: CardValues) -> NSAttributedString {
        let number = currentCard.number
        let symbol = currentCard.symbol
        let color = currentCard.color
        let shading = currentCard.shading
        
        let string = String(repeating: symbol.rawValue, count: number.rawValue)
        let attributes: [NSAttributedStringKey: Any]
        switch shading {
        case .solid:
            attributes = [.foregroundColor : color.color.withAlphaComponent(1.0)]
        case .open:
            attributes = [.strokeWidth : Constants.openStrokeWidth,
                          .strokeColor : color.color]
        case .striped:
            attributes = [.foregroundColor : color.color.withAlphaComponent(0.15)]
        }
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        return attributedString
    }
    
    private func addBorder(to button: UIButton, from card: Card) {
        let selectedCards = game.selectedCards
        let thereIsSet = game.thereIsSet
        
        if selectedCards.contains(card) {
            button.layer.borderWidth = CGFloat(Constants.buttonBorderWidth)
            if selectedCards.count == Constants.maximumSelectedCards {
                enable(allShownButtons: false) // so that the game won't crash
                if thereIsSet {
                    button.layer.borderColor = BorderColor.isSet.border
                } else {
                    button.layer.borderColor = BorderColor.noSet.border
                }
            } else {
                button.layer.borderColor = BorderColor.isSelected.border
            }
        } else {
            button.layer.borderColor = BorderColor.notSelected.border
        }
    }
    
    private func removeSelectedCardsAndBorder() { // REMOVE TIMERS WHEN ADDING ANIMATIONS
        self.timer = Timer.scheduledTimer(withTimeInterval: Constants.timeToShow, repeats: false, block: { [weak self] (currentTimer) in
            currentTimer.invalidate()
            
            if self?.game.thereIsSet ?? true {
                if self!.cardsLeftCount > 0 {
                    self?.game.removeSelectedAndAddNew()
                    self?.updateCardView()
                } else {
                    let alert = UIAlertController(title: "You won!", message: "The deck is now empty. Your score is \(self?.scoreCount ?? 0). Do you want to play again?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "New game", style: .default, handler: { [weak self] _ in
                        self?.startNewGame()
                    }))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
            
            self?.game.removeAllSelectedCards()
            for index in self?.cardButtons.indices ?? 0..<0 {
                if index < self?.currentlyShownCards ?? 0 {
                    self?.cardButtons[index].layer.borderColor = BorderColor.notSelected.border
                }
            }
            self?.enable(allShownButtons: true)
        })
    }
    
    private func startNewGame() {
        game.populateDeck()
        game.randomizeDeck()
        game.populateShownDeck(with: Constants.shownCards)
        
        scoreCount = Constants.initialScoreCount
        cardsLeftCount = Constants.initialCardsLeft
        currentlyShownCards = Constants.shownCards / 2
    }
    
    private func enable(allShownButtons enabled: Bool) {
        for index in cardButtons.indices {
            if index < currentlyShownCards {
                cardButtons[index].isEnabled = enabled
            }
        }
    }
    
}
