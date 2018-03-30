//
//  PlayingCardDeck.swift
//  PlayingCard
//
//  Created by Alexander on 23.01.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    var arc4random: Int {
        if self > 0 { return Int(arc4random_uniform(UInt32(self))) }
        else if self < 0 { return -Int(arc4random_uniform(UInt32(abs(self)))) }
        else { return 0 }
    }
}

extension Float {
    static var random: Float { return Float(arc4random()) / 0xFFFFFFFF }
    static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}

extension CGFloat {
    static var randomSign: CGFloat { return (arc4random_uniform(2) == 0) ? 1.0 : -1.0 }
    var random: CGFloat { return CGFloat(Float.random) }
}


struct PlayingCardDeck {
    private(set) var cards = [PlayingCard]()
    
    init() {
        for suit in PlayingCard.Suit.all {
            for rank in PlayingCard.Rank.all {
                cards.append(PlayingCard(suit: suit, rank: rank))
            }
        }
    }
    
    mutating func draw() -> PlayingCard? {
        if cards.count > 0 { return cards.remove(at: cards.count.arc4random) }
        else { return nil }
    }
}
