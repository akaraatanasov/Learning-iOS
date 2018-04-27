//
//  ViewController.swift
//  ResizableTextView
//
//  Created by Alexander on 23.04.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "textTableViewCell") as! TextViewTableViewCell
        
        cell.callBack = { textView in
            tableView.beginUpdates()
            textView.sizeToFit()
            tableView.endUpdates()
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
}

class TextViewTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    
    var callBack: ((UITextView) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.isScrollEnabled = false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        callBack?(textView)
    }
}
