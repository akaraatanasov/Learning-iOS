//
//  SetCardView.swift
//  Set
//
//  Created by Alexander on 15.02.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

extension CGRect {
    var leftHalf: CGRect { return CGRect(x: minX, y: minY, width: width/2, height: height) }
    var rightHalf: CGRect { return CGRect(x: midX, y: minY, width: width/2, height: height) }
    
    func inset(by size: CGSize) -> CGRect { return insetBy(dx: size.width, dy: size.height) }
    func sized(to size: CGSize) -> CGRect { return CGRect(origin: origin, size: size) }
    func zoom(by scale: CGFloat) -> CGRect {
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint { return CGPoint(x: x+dx, y: y+dy) }
}

extension SetCardView {
    private struct SizeRatio {
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.25
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    private var cornerRadius: CGFloat { return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight }
    private var cornerOffset: CGFloat { return cornerRadius * SizeRatio.cornerOffsetToCornerRadius }
    private var cornerFontSize: CGFloat { return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight }
}

@IBDesignable
class SetCardView: UIView {
    @IBInspectable
    var number: Int = 1 { didSet { setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var symbol: String = "▲" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var color: UIColor = UIColor.blue { didSet { setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var shading: String = "solid" { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    func createSetCardString() -> NSAttributedString {
        let string = String(String(repeating: symbol + "\n", count: number).dropLast(1))
        
        var attributes: [NSAttributedStringKey: Any]
        
        switch shading {
        case "solid":
            attributes = [.foregroundColor : color.withAlphaComponent(1.0)]
        case "open":
            attributes = [.strokeWidth : Constants.openStrokeWidth,
                          .strokeColor : color]
        case "striped":
            attributes = [.foregroundColor : color.withAlphaComponent(0.15)]
        default:
            attributes = [.foregroundColor : color.withAlphaComponent(1.0)]
        }
        
        var font = UIFont.preferredFont(forTextStyle: .body)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font).withSize(cornerFontSize)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        attributes[.paragraphStyle] = paragraphStyle
        attributes[.font] = font
        
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        return attributedString
    }
    
    private func drawCard() {
        let cardString = createSetCardString()
        
        let stringHeight = cardString.size().height
        let stringWidth = cardString.size().width
        
        let centerPoint = CGPoint(x: bounds.midX - stringWidth/2, y: bounds.midY - stringHeight/2)
        cardString.draw(at: centerPoint)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func draw(_ rect: CGRect) {
        drawCard()
    }
    
}
