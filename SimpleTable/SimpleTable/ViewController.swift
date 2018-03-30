//
//  ViewController.swift
//  SimpleTable
//
//  Created by Alexander on 15.03.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for count in 0...10 {
            tableData.append("Item \(count)")
        }
        
        print("The tableData array containts \(tableData)")
    }
    
    // MARK: UITableViewDataSource stubs
    
    // how many sections?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // how many rows?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    // what is this cell supossed to be?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        cell.textLabel!.text = tableData[indexPath.row]
        
        return cell
    }
    
    // MARK: UITableViewDelegate functions
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let messageString = "You tapped row \(indexPath.row)"
        
        let alertController = UIAlertController(title: "Row taped", message: messageString, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true) {
            print("\(messageString)")
        }
        
    }

}

