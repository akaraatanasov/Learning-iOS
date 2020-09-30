//
//  SendingVC.swift
//  DelegateMayhem
//
//  Created by Alexander on 31.01.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

protocol DataSentDelegate {
    func userDidEnterData(data: String)
}

class SendingVC: UIViewController {
    
    @IBOutlet weak var dataEntryTextField: UITextField!
    
    var delegate: DataSentDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    @IBAction func sendButtonWasPressed(_ sender: Any) {
        if delegate != nil {
            if let data = dataEntryTextField.text {
                delegate?.userDidEnterData(data: data)
                dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
}
