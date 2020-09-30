//
//  ActionViewController.swift
//  Extension
//
//  Created by Alexander Karaatanasov on 14.05.19.
//  Copyright © 2019 Alexander Karaatanasov. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    // MARK: - Vars
    
    private var pageTitle = ""
    private var pageURL = ""
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scriptTextView: UITextView!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButton()
        observeKeyboardNotifications()
        getJavaScriptPreprocessingResultsValues()
    }
    
    // MARK: - Private
    
    private func addBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }
    
    private func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func getJavaScriptPreprocessingResultsValues() {
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = "Console: \(self?.pageTitle ?? "")"
                    }
                }
            }
        }
    }
    
    private func sendJavaScript(code: String?) {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": code ?? ""]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    // MARK: - Action methods
    
    @objc private func doneTapped() {
        sendJavaScript(code: scriptTextView.text)
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scriptTextView.contentInset = .zero
        } else {
            scriptTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        scriptTextView.scrollIndicatorInsets = scriptTextView.contentInset
        
        let selectedRange = scriptTextView.selectedRange
        scriptTextView.scrollRangeToVisible(selectedRange)
    }

}
