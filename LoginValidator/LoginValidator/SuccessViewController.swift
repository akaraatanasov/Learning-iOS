//
//  SuccessViewController.swift
//  LoginValidator
//
//  Created by Alexander on 5.03.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController {
    
    // MARK: - Vars
    
    var username: String = ""
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var helloLabel: UILabel!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        helloLabel.text = "Hello, \(username)!"
    }

}
