//
//  ViewController.swift
//  LoginValidator
//
//  Created by Alexander on 2.03.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - @IBOutlets
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - @IBActions
    
    @IBAction func usernameFieldEditingChanged(_ sender: UITextField) {
        changeButtonState()
    }
    
    @IBAction func passwordFieldEditingChanged(_ sender: UITextField) {
        changeButtonState()
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        changeButtonState()
        
        if checkUsername() && checkPassword() {
            self.performSegue(withIdentifier: "successSegue", sender: self)
        } else {
            // probably never gonna execute
            let alertTitle = "Unsuccessful login attempt"
            var alertMessage = ""
            
            if checkUsername() {
                alertMessage = "Password is invalid"
            } else {
                alertMessage = "Username is invalid"
            }
            
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Try again", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Overrides
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "successSegue" {
            if let nextViewController = segue.destination as? SuccessViewController {
                if let username = usernameField.text {
                    nextViewController.username = username
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.isEnabled = false
    }
    
    // MARK: - Private methods
    
    private func changeButtonState() {
        loginButton.isEnabled = checkUsername() && checkPassword()
    }
    
    private func checkUsername() -> Bool {
        guard let username = usernameField.text else {
            return false
        }
        
        if username.contains("martin") {
            return true
        }
        return false
    }
    
    private func checkPassword() -> Bool {
        guard let password = passwordField.text else {
            return false
        }
        
        let match = password.range(of: "^(?=.*?[A-Z])(?=.*?[#?!@$%^&*-]).{8,}$", options: .regularExpression)
        let passwordRange = password.startIndex..<password.endIndex
        
        if match == passwordRange {
            return true
        }
        return false
    }
    
}
