//
//  TechniqueProjectRenderer.swift
//  HackingWithSwift
//
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

struct TechniqueProjectRenderer: ProjectRenderer {
    
    // MARK: - Vars
    
    var project: Project
    var colors = [UIColor(red: 238/255.0, green: 79/255.0, blue: 182/255.0, alpha: 1), UIColor(red: 201/255.0, green: 68/255.0, blue: 255/255.0, alpha: 1)]
    
    // MARK: - Inits
    
    init(for project: Project) {
        self.project = project
    }
    
}
