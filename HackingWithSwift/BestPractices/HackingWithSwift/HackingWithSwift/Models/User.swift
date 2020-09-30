//
//  User.swift
//  HackingWithSwift
//
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Foundation

struct User {
    
    // MARK: - Vars
    
    var name: NameObservable<String>
    var showProjects: ProjectsObservable<Int>

    // MARK: - Inits
    
    init(name: String = UserDefaults.standard.string(forKey: "UserName") ?? "Anonymous", showProjects: Int = UserDefaults.standard.integer(forKey: "UserProjects")) {
        self.name = NameObservable(name)
        self.showProjects = ProjectsObservable(showProjects)
    }
    
    // MARK: - Public

    func save() {
        UserDefaults.standard.set(name.value, forKey: "UserName")
        UserDefaults.standard.set(showProjects.value, forKey: "UserProjects")
    }
}
