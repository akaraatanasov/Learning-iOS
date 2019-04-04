//
//  User.swift
//  HackingWithSwift
//
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import Foundation

struct User {
    var name: String
    var showProjects: Int

    init(name: String = UserDefaults.standard.string(forKey: "UserName") ?? "Anonymous", showProjects: Int = UserDefaults.standard.integer(forKey: "UserProjects")) {
        self.name = name
        self.showProjects = showProjects
    }

    func save() {
        UserDefaults.standard.set(name, forKey: "UserName")
        UserDefaults.standard.set(showProjects, forKey: "UserProjects")
    }
}
