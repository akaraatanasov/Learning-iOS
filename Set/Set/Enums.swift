//
//  Enums.swift
//  Set
//
//  Created by Alexander on 19.01.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import Foundation
import UIKit

extension CardShading: Equatable {
    static func ==(lhs: CardShading, rhs: CardShading) -> Bool {
        return String(stringInterpolationSegment: lhs) == String(stringInterpolationSegment: rhs)
    }
}

enum CardNumber: Int {
    case one = 1
    case two = 2
    case three = 3
    
    static let allValues: [CardNumber] = [.one, .two, .three]
}

enum CardSymbol: String {
    case triangle = "▲"
    case circle = "●"
    case square = "■"
    
    static let allValues: [CardSymbol] = [.triangle, .circle, .square]
}

enum CardColor {
    case red
    case green
    case blue
    
    var color: UIColor {
        switch self {
        case .red:
            return UIColor.red
        case .blue:
            return UIColor.blue
        case .green:
            return UIColor.green
        }
    }
    
    static let allValues: [CardColor] = [.red, .green, .blue]
}

enum CardShading: String {
    case solid = "solid"
    case open = "open"
    case striped = "striped"
    
    static let allValues: [CardShading] = [.solid, .open, .striped]
}

enum BorderColor {
    case notSelected
    case isSelected
    case isSet
    case noSet
    
    var border: CGColor {
        switch self {
        case .notSelected:
            return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        case .isSelected:
            return #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        case .isSet:
            return #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        case .noSet:
            return #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
}
