//
//  SecondButtonTableViewController.swift
//  TableViewExample
//
//  Created by Alexander on 19.03.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

class SecondButtonTableViewController: UITableViewController {
    
    var collapsedSections = [Int]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        let nib = UINib(nibName: "TableSectionHeader", bundle: nil)
        tableView.register(nib, forHeaderFooterViewReuseIdentifier: "TableSectionHeader")
    }

    @objc func handleExpandCollapse(button: UIButton) {
        let section = button.tag
        
        if let index = collapsedSections.index(of: section) {
            collapsedSections.remove(at: index)
        } else {
            collapsedSections.append(section)
        }
    }
    
}


// MARK: - TableViewHeader
extension SecondButtonTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if collapsedSections.contains(section) {
            return 0
        }
        
        return super.tableView(tableView, numberOfRowsInSection: section) // returns default implementation
    }
    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Kur"
//    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableSectionHeader") as! TableSectionHeader
        
        let isSelected = !collapsedSections.contains(section)
        header.configureCell(withTitle: "Section \(section)", isSelected: isSelected)
//        header.headerButton.addTarget(self, action: #selector(handleExpandCollapse), for: .touchUpInside)
        header.indexOfSection = section
        header.delegate = self
        
        return header
    }
}

// MARK: - TableSectionHeaderDelegate
extension SecondButtonTableViewController: TableSectionHeaderDelegate {
    
    func buttonWasTappedInHeaderView(_ header: TableSectionHeader) {
        let section = header.indexOfSection
        
        if let index = collapsedSections.index(of: section) {
            collapsedSections.remove(at: index)
        } else {
            collapsedSections.append(section)
        }
    }
}
