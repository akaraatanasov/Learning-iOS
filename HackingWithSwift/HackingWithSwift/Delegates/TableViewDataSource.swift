//
//  TableViewDataSource.swift
//  HackingWithSwift
//
//  Created by Alexander Karaatanasov on 25.03.19.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import UIKit

class TableViewDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Vars
    
    var showingProjects = [Project]()
    
    // MARK: - Inits
    
    init(with projects: [Project] = [Project]()) {
        super.init()
        
        showingProjects = projects
    }
    
    // MARK: - Table View Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showingProjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let project = showingProjects[indexPath.row]
        cell.textLabel?.attributedText = project.attributedText
        return cell
    }
}
