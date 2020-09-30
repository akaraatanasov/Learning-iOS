//
//  SetCardDeck.swift
//  DrawingSet
//
//  Created by Alexander on 16.02.18.
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

struct SetCard {
    var number: CardNumber
    var symbol: CardSymbol
    var color: CardColor
    var shading: CardShading
}

struct SetCardDeck {
    private(set) var cards = [SetCard]()
    
    init() {
        for number in CardNumber.allValues {
            for symbol in CardSymbol.allValues {
                for color in CardColor.allValues {
                    for shading in CardShading.allValues {
                        let card = SetCard(number: number, symbol: symbol, color: color, shading: shading)
                        cards.append(card)
                    }
                }
            }
        }
    }
    
    mutating func draw() -> SetCard? {
        if cards.count > 0 { return cards.remove(at: cards.count.arc4random) }
        else { return nil }
    }
}
