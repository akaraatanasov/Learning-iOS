//
//  GameProjectRenderer.swift
//  HackingWithSwift
//
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

protocol GameRenderer: ProjectRendererDelegate { }

struct GameProjectRenderer: GameRenderer {
    
    // MARK: - Vars
    
    var project: Project
    var colors = [UIColor(red: 5/255.0, green: 203/255.0, blue: 175/255.0, alpha: 1), UIColor(red: 5/255.0, green: 190/255.0, blue: 58/255.0, alpha: 1)]
    var shadowColor = UIColor.green
    var imageText = "Game Project"
    
    // MARK: - Inits
    
    init(for project: Project) {
        self.project = project
    }

}

extension GameRenderer {
    func renderAdditionalComponents(in context: UIGraphicsImageRendererContext) {
        if let image = UIImage(named: "dice") {
            context.cgContext.translateBy(x: 300, y: 20)
            context.cgContext.rotate(by: .pi / 4)
            image.draw(in: CGRect(x: 0, y: 0, width: 100, height: 100), blendMode: .overlay, alpha: 1)
        }
    }
}
