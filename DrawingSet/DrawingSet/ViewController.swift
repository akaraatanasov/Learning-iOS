//
//  ViewController.swift
//  DrawingSet
//
//  Created by Alexander on 16.02.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var deck = SetCardDeck()
    
    @IBOutlet var cardViews: [SetCardView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var cards = [SetCard]()
        
        for _ in 1...81 {
            let card = deck.draw()!
            cards.append(card)
        }
        
        for cardView in cardViews { // translates model to the view
            let card = cards.remove(at: cards.count.arc4random)
            cardView.number = card.number.rawValue
            cardView.symbol = card.symbol.rawValue
            cardView.color = card.color.color
            cardView.shading = card.shading.rawValue
        }
    }

}

