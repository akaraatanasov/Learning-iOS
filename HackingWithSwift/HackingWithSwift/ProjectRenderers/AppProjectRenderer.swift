//
//  AppProjectRenderer.swift
//  HackingWithSwift
//
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

struct AppProjectRenderer: ProjectRenderer {
    
    // MARK: - Vars
    
    var project: Project
    var colors = [UIColor(red: 27/255.0, green: 215/255.0, blue: 253/255.0, alpha: 1), UIColor(red: 30/255.0, green: 98/255.0, blue: 241/255.0, alpha: 1)]
    
    // MARK: - Inits
    
    init(for project: Project) {
        self.project = project
    }
    
}
