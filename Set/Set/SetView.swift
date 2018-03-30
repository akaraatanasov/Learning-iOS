//
//  SetView.swift
//  Set
//
//  Created by Alexander on 16.02.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

class SetView: UIView {
    // MARK: - Vars
    
    private var game = Set()
    private var deck = SetCardDeck()
    private var cards = [SetCardView]()
    
    private var cellCount = 12 {
        didSet {
            setup()
        }
    }
    
    // MARK: - Override inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    // MARK: - Private
    
    func dealCards() {
        cellCount += 3
    }
    
    // add rotate gesture recognizer for randomizing cards
    
    private func setup() {
        // redraws cards - if not present the new cards show on top of the old ones
        subviews.forEach { $0.removeFromSuperview() }
        
        // PROBLEM IS THAT IT REMOVES EXCISTING CARDS
        // SOLUTION IS - SAVE PREVIOUS CARDS and dont use the deck.draw(), but to add a subview from cards array, and not directly from deck.draw()
        // ALSO when cellCount changes do not call setup(), but create addCards() and THEN redraw. (redraw can be in the addCards method)
        
        // creating our custom grid with 5:8 aspect ratio and SetView bounds as a frame
        var grid = Grid(layout: .aspectRatio(0.625), frame: CGRect(x: 0.0, y: 0.0, width: bounds.width, height: bounds.height))
        grid.cellCount = cellCount // adding the cellCount
        
        for cardNumber in 0..<cellCount {
            guard let frame = grid[cardNumber] else {
                continue // if there is NOT such a frame in the grid, countinue with next itteration
            }
            
            // customizing the frame a little bit so that it can has padding
            let frameX = frame.minX + 2
            let frameY = frame.minY + 2
            let frameWidth = frame.size.width - 5
            let frameHeight = frame.size.height - 5
            let frameWithPadding = CGRect(x: frameX, y: frameY, width: frameWidth, height: frameHeight)
            
            let card = SetCardView(frame: frameWithPadding) // initializing card with the custom frame
            let tap = UITapGestureRecognizer(target: self, action:  #selector(self.tapAction)) // create tap gesture

            
            card.addGestureRecognizer(tap) // adding the tap gesture to the card
            card.backgroundColor = UIColor.white // setting the card background color to be white
            card.layer.cornerRadius = CGFloat(card.bounds.size.height * 0.06) // setting corner radius
            card.clipsToBounds = true // clip card to bounds so that there are no white sharp corners
            card.symbol = "?"
            
            if let cardData = deck.draw() { // gets card from deck and sets values
                card.number = cardData.number.rawValue
                card.symbol = cardData.symbol.rawValue
                card.color = cardData.color.color
                card.shading = cardData.shading.rawValue
            }
            
            cards.append(card)
            addSubview(card)
        }
        
    }
    
    @objc func tapAction(sender: UITapGestureRecognizer) {
        guard let cardView = sender.view as? SetCardView else {
            return
        }
        
        if let cardNumber = cards.index(of: cardView) {
            game.chooseCard(at: cardNumber)
            
            
            
        } else {
            print("chosen card was not in cards")
        }
    }
}
