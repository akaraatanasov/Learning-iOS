//
//  ViewController.swift
//  ConcentrationGame
//
//  Created by Alexander on 8.01.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var flipCount = -1 { // -1 because of the initial flipping
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    var lastFlippedCardIndex: Int = 0;
    var cardIsFlipped: Bool = false;
    var emojiChoices = ["🎃", "👻", "🖤", "💻",
                        "🇧🇬", "📱", "🎮", "⚡️",
                        "🍀", "⌚️", "👻", "🍀",
                        "💻", "🇧🇬", "📱", "⚡️",
                        "🎃", "⌚️", "🎮", "🖤"];
    
    var timer: Timer!
    var cardsShown = 0
    
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    
    var unmatchedCards: [UIButton] = [] // var unmatchedCards: [UIButton]! also possible
    
    override func viewDidLoad() {
        unmatchedCards = cardButtons
    }
    
    @IBAction func touchCard(_ sender: UIButton) {
        if flipCount == -1 {
            showAllCards()
            flipCount += 1
        } else {
            guard let cardIndex = cardButtons.index(of: sender) else {
                print("chosen card was not in cardButtons")
                
                return
            }
            print("cardIndex = \(cardIndex)");
            
            flipCard(withEmoji: emojiChoices[cardIndex], on: sender)
            
            if cardIsFlipped {
                for button in unmatchedCards {
                    button.isEnabled = false
                }
                
                if sender.currentTitle == emojiChoices[lastFlippedCardIndex] {
                    print("match between \(cardIndex) and \(lastFlippedCardIndex)")
                    
                    if let currentElementIndex = unmatchedCards.index(of: cardButtons[cardIndex]),
                        let lastFlippedIndex = unmatchedCards.index(of: cardButtons[lastFlippedCardIndex]) {
                        unmatchedCards.remove(at: currentElementIndex)
                        unmatchedCards.remove(at: lastFlippedIndex)
                    }
                    
                    for button in unmatchedCards {
                        button.isEnabled = true
                    }
    
                } else {
                    print("no match!")
                    
                    self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (currentTimer) in
                        currentTimer.invalidate()
                        self.hideCard(on: self.cardButtons[self.lastFlippedCardIndex])
                        self.hideCard(on: sender)
                        
                        for button in self.unmatchedCards {
                            button.isEnabled = true
                        }
                    })
                }
                
                cardIsFlipped = false;
                //lastFlippedCardIndex = cardIndex;
                
                if unmatchedCards.count == 0 {
                    let alertController = UIAlertController(title: "Success", message: "You win", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    let playAgainAction = UIAlertAction(title: "Play again", style: .default, handler: { (_) in
                        print("Play again")
                    })
                    
                    alertController.addAction(okAction)
                    alertController.addAction(playAgainAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
            } else {
                cardIsFlipped = true;
                lastFlippedCardIndex = cardIndex;
            }
            
        }
    }
    
    func flipCard(withEmoji emoji: String, on button: UIButton) {
        if button.currentTitle == emoji {
            hideCard(on: button)
        } else {
            showCard(withEmoji: emoji, on: button)
            flipCount += 1
        }
    }
    
    func hideCard(on button: UIButton) {
        button.setTitle("", for: UIControlState.normal)
        button.isEnabled = true;
        button.backgroundColor = #colorLiteral(red: 0.5455184579, green: 0.5459486246, blue: 0.5455850959, alpha: 1)
    }
    
    func showCard(withEmoji emoji: String, on button: UIButton) {
        button.setTitle(emoji, for: UIControlState.normal)
        button.isEnabled = false;
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
    }
    
    func showAllCards() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: { (currentTimer) in
            print("Date: \(NSDate()), cards: \(self.cardsShown)")
            self.showCard(withEmoji: self.emojiChoices[self.cardsShown], on: self.cardButtons[self.cardsShown])
            self.cardsShown += 1
            
            if self.cardsShown == self.cardButtons.count {
                currentTimer.invalidate()
                self.cardsShown = 0
                // initiating hideAllCards
                self.timer = Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false, block: { (currentTimer) in
                    currentTimer.invalidate()
                    self.hideAllCard()
                })
            }
        })
    }
    
    func hideAllCard() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true, block: { (currentTimer) in
            print("Date: \(NSDate()), cards: \(self.cardsShown)")
            self.hideCard(on: self.cardButtons[self.cardsShown])
            self.cardsShown += 1
            
            if self.cardsShown == self.cardButtons.count {
                currentTimer.invalidate()
            }
        })
    }
    
}

