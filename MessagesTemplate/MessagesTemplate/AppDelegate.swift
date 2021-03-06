//
//  AppDelegate.swift
//  MessagesTemplate
//
//  Created by Alexander on 25.05.18.
//  Copyright © 2018 Alexander. All rights reserved.
//

import UIKit
import UserNotifications
import SwiftMessages

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        registerForPushNotifications()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Push Notifications
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications with error: \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        showMessageFrom(notificationData: notification)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        handleNotificationActionFrom(response: response)
        
        completionHandler()
    }   
    
}

// MARK: - Notification payload
//{
//    "aps": {
//        "alert":{
//            "title":"Some message",
//            "body":"Hi, this is the first message I have ever send! Hope you like it! 🍓"
//        },
//        "category":"notificationWithActions",
//        "badge":1,
//        "sound":"default",
//        "mutable-content": 1,
//        "attachment-url": "https://tinyurl.com/y9exh3by"
//    }
//}

extension AppDelegate {
    
    private func showMessageFrom(notificationData notification: UNNotification) {
        var config = SwiftMessages.Config()
        config.duration = .seconds(seconds: 3)
        
        let notificationView = MessageView.viewFromNib(layout: .cardView)
        notificationView.configureTheme(.info)
        notificationView.configureDropShadow()
        
        let aps = notification.request.content.userInfo["aps"] as! [String: Any]
        let alert = aps["alert"] as! [String: Any]
        let title = alert["title"] as? String
        let body = alert["body"] as? String
        var iconImage: UIImage?
        
        do {
            if let url = aps["attachment-url"] as? String {
                let imageData = try Data(contentsOf: URL(string: url)!)
                let image = UIImage(data: imageData)!
                iconImage = image
            }
        } catch {
            print (error.localizedDescription)
        }
        
        notificationView.configureContent(title: title, body: body, iconImage: iconImage, iconText: nil, buttonImage: nil, buttonTitle: "Save") { (button) in
            UIImageWriteToSavedPhotosAlbum(iconImage!, nil, nil, nil)
            self.presentSavedAlert()
        }
        notificationView.configureIcon(withSize: CGSize(width: 90, height: 90), contentMode: .scaleAspectFit)
        
        SwiftMessages.show(config: config, view: notificationView)
    }
    
    private func handleNotificationActionFrom(response notificationResponse: UNNotificationResponse) {
        switch notificationResponse.actionIdentifier {
        case "open":
            print("Open action was chosen")
        case "save attachment":
            print("Save action was chosen")
            
            let aps = notificationResponse.notification.request.content.userInfo["aps"] as! [String: Any]
            let url = URL(string: aps["attachment-url"] as! String)!
            
            do {
                let imageData = try Data(contentsOf: url)
                saveToPhotoLibrary(thisImage: imageData)
                presentSavedAlert()
            } catch {
                print (error.localizedDescription)
            }
        default:
            print("No custom action identifiers chosen")
        }
    }
    
    private func saveToPhotoLibrary(thisImage imageData: Data) {
        let image = UIImage(data: imageData)!
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    private func presentSavedAlert() {
        let alert = UIAlertController(title: "Saved", message: "Your image has been saved", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        
        var hostVC = self.window?.rootViewController
        while let next = hostVC?.presentedViewController {
            hostVC = next
        }
        hostVC?.present(alert, animated: true, completion: nil)
        
    }
}
