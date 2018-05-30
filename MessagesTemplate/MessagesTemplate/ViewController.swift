//
//  ViewController.swift
//  MessagesTemplate
//
//  Created by Alexander on 25.05.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

enum SendAction {
    case edit
    case add
}

class ViewController: UIViewController {
    // MARK: - Vars
    var cellData = ["First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh", "Eight"]
    var sendButtonAction: SendAction = .add
    var cellToEditIndex: IndexPath = IndexPath(item: 0, section: 0)
    var lastCellIndex: IndexPath {
        get {
            return IndexPath(row: cellData.count - 1, section: 0)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textAndButtonView: UIView!
    
    @IBOutlet weak var textAndButtonViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    // MARK: - Private
    private func initialSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(sender:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(sender:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(longPressGestureRecognizer:)))
        tableView.addGestureRecognizer(longPressRecognizer)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 43.5
        
        textView.delegate = self
        sendButton.titleLabel?.textAlignment = .center
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
    
    @objc private func keyboardWillShow(sender: Notification) {
        moveTextAndButtonView(for: sender, up: true)
    }
    
    @objc private func keyboardWillHide(sender: Notification) {
        moveTextAndButtonView(for: sender, up: false)
    }
    
    private func moveTextAndButtonView(for sender: Notification, up moveUp: Bool) {
        guard let keyboardSize = sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardSize.cgRectValue.height
        textAndButtonViewBottomConstraint.constant = moveUp ? keyboardHeight : 0
        
        let keyboardAnimationDuration = sender.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double ?? 0.25
        UIView.animate(withDuration: keyboardAnimationDuration, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        });
    }
    
    private func editCell(at indexPath: IndexPath) {
        textView.text = cellData[indexPath.row]
        cellToEditIndex = indexPath
        tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
        changeSendButton(toEdit: true)
    }
    
    private func deleteCell(at indexPath: IndexPath) {
        cellData.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    private func scrollToBottom() {
        tableView.scrollToRow(at: lastCellIndex, at: UITableViewScrollPosition.bottom, animated: true)
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
        if let text = textView.text, !text.isEmpty {
            switch sendButtonAction {
            case .add:
                cellData.append(text)
                tableView.insertRows(at: [lastCellIndex], with: .automatic)
                scrollToBottom()
            case .edit:
                cellData[cellToEditIndex.row] = text
                tableView.reloadRows(at: [cellToEditIndex], with: .automatic)
                changeSendButton(toEdit: false)
            }
            
            textView.text = ""
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! ResizableTableViewCell
        cell.cellLabel?.text = cellData[indexPath.row]
        return cell
    }
}

// MARK: - UITextViewDelegate
extension ViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
}