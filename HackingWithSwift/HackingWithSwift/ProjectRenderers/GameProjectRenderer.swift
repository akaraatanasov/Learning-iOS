//
//  GameProjectRenderer.swift
//  HackingWithSwift
//
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

struct GameProjectRenderer: ProjectRenderer {
    
    // MARK: - Vars
    
    var project: Project
    var colors = [UIColor(red: 5/255.0, green: 203/255.0, blue: 175/255.0, alpha: 1), UIColor(red: 5/255.0, green: 190/255.0, blue: 58/255.0, alpha: 1)]
    
    // MARK: - Inits
    
    init(for project: Project) {
        self.project = project
    }
    
}
