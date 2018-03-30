//
//  Set.swift
//  Set
//
//  Created by Alexander on 17.01.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    func shuffle() -> Array {
        var shuffledArray = self
        
        for index in 0..<self.count {
            let randomIndex = Int(arc4random_uniform(UInt32(index)))
            shuffledArray.swapAt(index, randomIndex)
        }
        
        return shuffledArray
    }
}

struct CardValues {
    var number: CardNumber
    var symbol: CardSymbol
    var color: CardColor
    var shading: CardShading
    
    init(number: CardNumber, symbol: CardSymbol, color: CardColor, shading: CardShading) {
        self.number = number
        self.symbol = symbol
        self.color = color
        self.shading = shading
    }
}

class Set {
    // MARK: - Vars
    
    private(set) var cards = [Card]()
    private(set) var deck = [Card : CardValues]()
    
    private(set) var shownCards = [Card]()
    private(set) var shownDeck = [Card : CardValues]()
    
    private(set) var selectedCards = [Card]()
    private(set) var thereIsSet: Bool = false
    
    init() {
        generateCards()
        populateDeck()
        randomizeDeck()
        populateShownDeck(with: Constants.shownCards)
    }
    
    // MARK: - Private
    
    private func generateCards() {
        for _ in 1...Constants.allCards {
            let card = Card()
            cards += [card]
        }
    }
    
    private func resetGame() {
        deck.removeAll()
        cards.removeAll()
        shownDeck.removeAll()
        shownCards.removeAll()
    }
    
    private func isSet() -> Bool {
        let firstCard = shownDeck[selectedCards[0]]
        let secondCard = shownDeck[selectedCards[1]]
        let thirdCard = shownDeck[selectedCards[2]]
        
        let numberCondition = allOrNothing(first: firstCard?.number, second: secondCard?.number, third: thirdCard?.number)
        let symbolCondition = allOrNothing(first: firstCard?.symbol, second: secondCard?.symbol, third: thirdCard?.symbol)
        let colorCondition = allOrNothing(first: firstCard?.color, second: secondCard?.color, third: thirdCard?.color)
        let shadingCondition = allOrNothing(first: firstCard?.shading, second: secondCard?.shading, third: thirdCard?.shading)
        
        if numberCondition &&
            colorCondition &&
            symbolCondition &&
            shadingCondition {
            return true
        } else {
            return false
        }
    }
    
    private func allOrNothing<T: Equatable>(first: T?, second: T?, third: T?) -> Bool {
        if  (first == second &&
            second == third &&
            third == first) {
            return true
        } else if
            first != second &&
                second != third &&
                third != first {
            return true
        } else {
            return false
        }
    }
    
    private func replaceSelectedCards() {
        for selectedCard in selectedCards {
            let lastIndexOfDeck = deck.count - 1
            for indexOfCardToReplace in shownCards.indices {
                if shownCards[indexOfCardToReplace] == selectedCard {
                    shownCards[indexOfCardToReplace] = cards[lastIndexOfDeck] // replaces Card from shownCards
                    break;
                }
            }
            let currentCard = cards.remove(at: lastIndexOfDeck)
            shownDeck[currentCard] = deck.removeValue(forKey: currentCard) // replaces CardValue from shownDeck
        }
    }
    
    // MARK: - Public
    
    // MARK: - Card methods
    func chooseCard(at index: Int) {
        assert(shownCards.indices.contains(index), "Set.chooseCard(at: \(index)): chosen index not in the cards")
        
        let card = shownCards[index]
        if selectedCards.contains(card) { // checks if the card is already selected
            var removeIndex: Int = 0
            for indexSelectedCards in selectedCards.indices {
                if card == selectedCards[indexSelectedCards] {
                    removeIndex = indexSelectedCards
                }
            }
            selectedCards.remove(at: removeIndex)
        } else {
            selectedCards.append(card) // else it adds it to selectedCards array
        }
        
        print(selectedCards) // REMOVE after done
        
        if selectedCards.count == Constants.maximumSelectedCards {
            thereIsSet = isSet()
            selectedCards.removeAll()
            print(thereIsSet) // REMOVE after done
        }
    }
    
    func removeSelectedAndAddNew() {
        if selectedCards.count == Constants.maximumSelectedCards {
            replaceSelectedCards()
        } else {
            print("removeSelectedAndAddNew: I wasn't meant to be called")
        }
    }
    
    func removeAllSelectedCards() {
        selectedCards.removeAll()
    }
    
    // MARK: - Deck methods
    func randomizeDeck() {
        cards = cards.shuffle()
    }
    
    func populateDeck() {
        if deck.count > 0 {
            resetGame()
            generateCards()
        }
    
        var cardIndex = 0;
        for number in CardNumber.allValues {
            for symbol in CardSymbol.allValues {
                for color in CardColor.allValues {
                    for shading in CardShading.allValues {
                        let card = CardValues(number: number, symbol: symbol, color: color, shading: shading)
                        deck[cards[cardIndex]] = card
                        cardIndex += 1
                    }
                }
            }
        }
    }
    
    func populateShownDeck(with numOfCards: Int) {
        let lastIndexOfDeck = deck.count - 1
        let startIndex = lastIndexOfDeck - numOfCards + 1
        
        if deck.count >= numOfCards {
            for index in (startIndex...lastIndexOfDeck).reversed() {
                let currentCard = cards[index]
                shownCards.append(cards.remove(at: index))
                shownDeck[currentCard] = deck.removeValue(forKey: currentCard)
            }
        } else {
            print("There are not enough cards in the deck!")
        }
    }
    
}
