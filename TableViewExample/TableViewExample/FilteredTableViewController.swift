//
//  FilteredTableViewViewController.swift
//  TableViewExample
//
//  Created by Alexander on 22.03.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

class FilteredTableViewController: UIViewController {
    
    let arrayWithNames = ["Martin", "Hristiyan", "Ralitsa", "Dimitar", "Yoanna", "Alexander", "Sando", "Deyan", "Bogomil", "Polina", "Petyo", "Bianka", "Marto", "Ico", "Ice", "Rali", "Mitko", "Sasho", "Yoni", "Dido", "Poli", "Marti", "Paola", "Lora", "Ivan", "Peter", "Kaloyan", "Boris", "Misho", "Diana", "Volena", "Cvetina", "Zornica", "Mihaela", "Vesela", "Kristiyan", "Lisa", "Shannys", "Ivaylo", "Katrin", "Vladimir", "Vladislava", "Velizar", "Mario", "Nikola", "Meti", "Mari", "Ricy", "Desislav", "Anna"]
    
    var filteredArray = [String]() {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredArray = arrayWithNames
    }

    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        if let textFromTextField = sender.text {
            filteredArray = arrayWithNames.filter {
                $0.lowercased().contains(textFromTextField.lowercased())
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension FilteredTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            filteredArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            tableView.endUpdates()
        }
    }
    
}

// MARK: - UITableViewDataSource
extension FilteredTableViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Filtered cells"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filteredCell")!
        cell.textLabel!.text = filteredArray[indexPath.row]
        return cell
    }
    
}
