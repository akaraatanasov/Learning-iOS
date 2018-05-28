//
//  ViewController.swift
//  MessagesTemplate
//
//  Created by Alexander on 25.05.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

// To-do:
// 1. fix the bug with the selection - done
// 1.1. Make the textfield a textview that resizes up to 4 lines

// 2. delete cell with the cell datasource method
// 3. insert cell ??

import UIKit

enum SendAction {
    case edit
    case add
}

class ViewController: UIViewController {
    
    var cellData = ["First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eight"] {
        didSet {
            tableView.reloadData()
            scrollToBottom()
        }
    }
    
    var sendButtonAction: SendAction = .add
    var cellToEditIndex: Int = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textAndButtonView: UIView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    // MARK: - Private
    private func initialSetup() {
        sendButton.titleLabel?.textAlignment = .center
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(longPressGestureRecognizer:)))
        tableView.addGestureRecognizer(longPressRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = longPressGestureRecognizer.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                let alertController = UIAlertController(title: "Message options", message: "What would you like to do?", preferredStyle: .actionSheet)
                
                let editButton = UIAlertAction(title: "Edit", style: .default, handler: { action -> Void in
                    self.editCell(at: indexPath)
                })
                let deleteButton = UIAlertAction(title: "Delete", style: .destructive, handler: { action -> Void in
                    self.deleteCell(at: indexPath)
                })
                let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alertController.addAction(editButton)
                alertController.addAction(deleteButton)
                alertController.addAction(cancelButton)
                
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @objc func keyboardWillShow(sender: Notification) {
        moveTextAndButtonView(for: sender, up: true)
    }
    
    @objc func keyboardWillHide(sender: Notification) {
        moveTextAndButtonView(for: sender, up: false)
    }
    
    private func moveTextAndButtonView(for sender: Notification, up moveUp: Bool) {
        guard let keyboardSize = sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardSize.cgRectValue.height
        let posY = self.textAndButtonView.frame.origin.y + (moveUp ? -keyboardHeight : keyboardHeight)
        tableViewHeightConstraint.constant = tableViewHeightConstraint.constant + (moveUp ? -keyboardHeight : keyboardHeight)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.textAndButtonView.frame = CGRect(x: self.textAndButtonView.frame.origin.x, y: posY, width: self.textAndButtonView.frame.size.width, height: self.textAndButtonView.frame.size.height)
        });
    }
    
    private func editCell(at indexPath: IndexPath) {
        textField.text = cellData[indexPath.row]
        cellToEditIndex = indexPath.row
        changeSendButton(toEdit: true)
    }
    
    private func deleteCell(at indexPath: IndexPath) {
        cellData.remove(at: indexPath.row)
    }
    
    private func scrollToBottom() {
        let lastIndex = IndexPath(row: cellData.count - 1, section: 0)
        self.tableView.scrollToRow(at: lastIndex, at: UITableViewScrollPosition.bottom, animated: true)
    }
    
    private func changeSendButton(toEdit isEditButton: Bool) {
        if isEditButton {
            sendButtonAction = .edit
            sendButton.titleLabel?.text = "Edit"
        } else {
            sendButtonAction = .add
            sendButton.titleLabel?.text = "Send"
        }
    }
    
    // MARK: - IBAction
    @IBAction func sendButton(_ sender: Any) {
        if let text = textField.text, !text.isEmpty {
            switch sendButtonAction {
            case .add:
                cellData.append(text)
            case .edit:
                cellData[cellToEditIndex] = text
                changeSendButton(toEdit: false)
            }
            textField.text = ""
        }
    }
    
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        cell.textLabel?.text = cellData[indexPath.row]
        return cell
    }
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
