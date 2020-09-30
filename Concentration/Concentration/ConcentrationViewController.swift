//
//  ViewController.swift
//  Concentration
//
//  Created by Alexander on 10.01.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

class ConcentrationViewController: UIViewController {
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private(set) var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedStringKey : Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    var theme: String? {
        didSet {
            emojiChoices = theme ?? ""
            emoji = [:]
            updateViewFromModel()
        }
    }
    
//    private var emojiChoices = ["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎", "🖤"]
    private var emojiChoices = "🦇😱🙀😈🎃👻🍭🍬🍎🖤💖⚡️💻🇧🇬🍀🎮🖥⌚️😽😘😂📱🙂😻💩"
    private var emoji = [Card : String]() // = Dictionary<Int, String>()
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        
        return emoji[card] ?? "?"
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    private var visibleCardButtons: [UIButton]! {
        return cardButtons?.filter { !$0.superview!.isHidden }
    }
    
    private func flipCard(withEmoji emoji: String, on button: UIButton) {
        if button.currentTitle == emoji {
            button.setTitle("", for: UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
        } else {
            button.setTitle(emoji, for: UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = visibleCardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    private func newGame(alert: UIAlertAction!) {
        game.unmatchAllCards()
        game.randomizeCards()
        updateViewFromModel()
        flipCount = 0
    }
    
    private func updateViewFromModel() {
        if visibleCardButtons != nil {
            if game.matchedCardsCount == visibleCardButtons.count / 2 {
                print("game finished")
                hideAllCards()
                
                let alert = UIAlertController(title: "You won!", message: "Congartulations! It took you \(flipCount) flips to win the game. Next time try doing it with fewer flips!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: newGame))
                
                self.present(alert, animated: true, completion: nil)
            }
            
            updateCardView()
        }
    }
    
    private func updateCardView() {
        for index in visibleCardButtons.indices {
            let button = visibleCardButtons[index]
            let card = game.cards[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                button.isEnabled = false
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0) : #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
                button.isEnabled = true
            }
            
            if card.isMatched {
                button.isEnabled = false
            }
        }
    }
    
    private func hideAllCards() {
        for index in visibleCardButtons.indices {
            let button = visibleCardButtons[index]
            
            button.setTitle("", for: UIControlState.normal)
            button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0)
            button.isEnabled = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateViewFromModel()
    }
}

