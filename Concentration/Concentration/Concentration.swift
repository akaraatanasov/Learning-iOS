//
//  Concentration.swift
//  Concentration
//
//  Created by Alexander on 10.01.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import Foundation

struct Concentration {
    var matchedCardsCount = 0 // NOT NICE!
    var lastMatchedCards = [Card]() // = cards[0] // NOT NICE TOO!
    
    private(set) var cards = [Card]() // = Array<Card>()
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
//            var foundIndex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    
                    matchedCardsCount += 1
                    lastMatchedCards = [cards[matchIndex], cards[index]]
                }
                cards[index].isFaceUp = true
            } else {
                // either no cards or 2 cards are face up
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    mutating func unmatchAllCards() {
        for index in 0..<cards.count {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
        }
        matchedCardsCount = 0
    }
    
    func shuffleArray<T>(array: Array<T>) -> Array<T> {
        var shuffledArray = array
        // for (index, _) in array.enumerated() { - returns tuple of index and content (pair)
        for index in 0..<array.count {
            let randomIndex = Int(arc4random_uniform(UInt32(index)))
            shuffledArray.swapAt(index, randomIndex)
        }
        
        return shuffledArray
    }

    mutating func randomizeCards() {
        // cards = shuffleArray(array: cards)
        cards = cards.shuffle()
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        
        randomizeCards()
    }

}

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

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
