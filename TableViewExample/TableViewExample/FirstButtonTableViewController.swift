//
//  ExampleViewController.swift
//  TableViewExample
//
//  Created by Alexander on 19.03.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

private enum Section: Int {
    case basic = 0
    case custom = 1
    
    static var allValues: [Section] {
        return [.basic, .custom]
    }
}

class FirstButtonTableViewController: UIViewController {
    
    var basicItems = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
    var customItems = ["Cell 1", "Cell 2", "Cell 3", "Cell 4", "Cell 5", "Cell 6"]

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    // MARK: - IBActions
    @IBAction func editButton(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        
        editButton.title = tableView.isEditing ? "Done" : "Edit"
    }
    
}

// MARK: - UITableViewDelegate
extension FirstButtonTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let sectionType = Section(rawValue: indexPath.section)!
            
            tableView.beginUpdates()
            
            switch sectionType {
            case .basic:
                basicItems.remove(at: indexPath.row)
            case .custom:
                customItems.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
    
}

// MARK: - UITableViewDataSource
extension FirstButtonTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allValues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionType = Section(rawValue: section)!
        
        switch sectionType {
        case .basic:
            return basicItems.count
        case .custom:
            return customItems.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionType = Section(rawValue: indexPath.section)!
        
        switch sectionType {
        case .basic:
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell")!
            cell.textLabel!.text = basicItems[indexPath.row]
            return cell
            
        case .custom:
            let cell = tableView.dequeueReusableCell(withIdentifier: "reallyCustomCell") as! CustomCell
            cell.configureCell(with: customItems[indexPath.row], and: #imageLiteral(resourceName: "sol"))
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sectionType = Section(rawValue: sourceIndexPath.section)!
        
        print("----------------------------------Before----------------------------------")
        print("basicItems: \(basicItems)")
        print("customItems: \(customItems)")
        
        switch sectionType {    
        case .basic:
            moveItems(origin: &basicItems, destination: &customItems, originIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
        case .custom:
            moveItems(origin: &customItems, destination: &basicItems, originIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
        }
        
        print("----------------------------------After-----------------------------------")
        print("basicItems: \(basicItems)")
        print("customItems: \(customItems)")
        print()
    }
    
    func moveItems( origin: inout [String], destination: inout [String], originIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        let itemToMove = origin[originIndexPath.row]
        origin.remove(at: originIndexPath.row)
        
        if originIndexPath.section == destinationIndexPath.section {
            origin.insert(itemToMove, at: destinationIndexPath.row)
        } else {
            destination.insert(itemToMove, at: destinationIndexPath.row)
        }
    }
}
