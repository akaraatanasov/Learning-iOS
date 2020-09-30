//
//  ViewController.swift
//  Project21-LocalNotifications
//
//  Created by Alexander Karaatanasov on 15.05.19.
//  Copyright © 2019 Alexander Karaatanasov. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarButtons()
        removeAllPendingNotifications()
    }
    
    // MARK: - Private
    
    private func setupBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleTapped))
    }
    
    private func presentAlert(withTitle title: String?, andMessage message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
    
    // MARK: - Notification methods
    
    private func registerLocalNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }
    
    private func registerNotificationCategories() {
        UNUserNotificationCenter.current().delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
        let remind = UNNotificationAction(identifier: "remind", title: "Remind me later", options: [])
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remind], intentIdentifiers: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
    
    private func scheduleLocalNotification(after timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = "Title goes here"
        content.body = "Main text goes here"
        content.categoryIdentifier = "customIdentifier"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "alarm"
        
//        var dateComponents = DateComponents()
//        dateComponents.hour = 10
//        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    private func removeAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // MARK: - Action methods
    
    @objc private func registerTapped() {
        registerLocalNotifications()
    }
    
    @objc private func scheduleTapped() {
        registerNotificationCategories()
        scheduleLocalNotification(after: 5)
    }

}

// MARK: - User Notification Center Delegate

extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                presentAlert(withTitle: "App opened", andMessage: "You just opened the app by swiping the notification.")
            case "show":
                presentAlert(withTitle: "App opened", andMessage: "You just opened the app by pressing the \"Show more information…\" action.")
            case "remind":
                scheduleLocalNotification(after: 5)
            default:
                break
            }
        }
        
        completionHandler()
    }
}
