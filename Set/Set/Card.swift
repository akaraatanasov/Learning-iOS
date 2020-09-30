//
//  Card.swift
//  Set
//
//  Created by Alexander on 17.01.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import Foundation

struct Card: Hashable {
    var hashValue: Int {
        return identifier
    }
    
    // H: Is this the best way to compare cards? Can't you think of a better way?
    // A: Card has only identifier, so yeah - this is the best and only way to compare them
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private var identifier: Int
   
    // H: private static ????
    // A: This generates different id for every card
    private static var identifierFactory = 0

    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return Card.identifierFactory
    }
    
    init () {
        self.identifier = Card.getUniqueIdentifier()
    }
}
