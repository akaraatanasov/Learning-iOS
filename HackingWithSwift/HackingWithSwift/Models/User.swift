//
//  User.swift
//  HackingWithSwift
//
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Foundation

struct User {
    
    // MARK: - Vars
    
    var name: String
    var showProjects: Int

    // MARK: - Inits
    
    init(name: String = UserDefaults.standard.string(forKey: "UserName") ?? "Anonymous", showProjects: Int = UserDefaults.standard.integer(forKey: "UserProjects")) {
        self.name = name
        self.showProjects = showProjects
    }
    
    // MARK: - Public

    func save() {
        UserDefaults.standard.set(name, forKey: "UserName")
        UserDefaults.standard.set(showProjects, forKey: "UserProjects")
    }
}
