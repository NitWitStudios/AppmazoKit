//
//  PermissionsManager+Notifications.swift
//  AppmazoKit
//
//  Created by James Hickman on 5/13/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import Foundation
import UserNotifications

extension PermissionsManager {
    static private let notificationsEnabledForSimulators = "notificationsEnabledForSimulators"

    // MARK: - Private
    
    private func isSimulatorNotificationsEnabled() -> Bool {
        #if targetEnvironment(simulator)
        return UserDefaults.standard.bool(forKey: PermissionsManager.notificationsEnabledForSimulators)
        #endif
        return false
    }
    
    private func enableNotificationsForSimulators() {
        UserDefaults.standard.set(true, forKey: PermissionsManager.notificationsEnabledForSimulators)
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - Public
    
    public func isNotificationsAuthorized() -> Bool {
        return UIApplication.shared.isRegisteredForRemoteNotifications || isSimulatorNotificationsEnabled()
    }

    public func requestNotificationsPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self]
            (granted, error) in
            if granted {
                #if targetEnvironment(simulator)
                self?.enableNotificationsForSimulators()
                #endif

                DispatchQueue.main.async {
                    let viewAction = UNNotificationAction(identifier: "view", title: "View", options: [.foreground])
                    let defaultCategory = UNNotificationCategory(identifier: "defaultCategory", actions: [viewAction], intentIdentifiers: [], options: [])
                    
                    UNUserNotificationCenter.current().setNotificationCategories([defaultCategory])
                    UIApplication.shared.registerForRemoteNotifications()
                    self?.permissionsUpdatedBlock?(.notifications)
                }
            } else if let error = error {
                let alertViewController = AlertViewController.alertControllerWithTitle("Uh-Oh", message: error.localizedDescription)
                alertViewController.addAction(AlertAction.actionWithTitle("Dismiss", style: .button, handler: nil))
                UIApplication.shared.keyWindow?.rootViewController?.present(alertViewController, animated: true, completion: nil)
            } else {
                let alertViewController = AlertViewController.alertControllerWithTitle("Uh-Oh", message: "Looks like you previously set notifications authorization for our app.\nPlease visit the Settings App and change the notifications permissions there.")
                alertViewController.addAction(AlertAction.actionWithTitle("Go to Settings", style: .button, handler: { (alertAction) in
                    UIApplication.shared.open(URL(string:UIApplicationOpenSettingsURLString)!, options:[:], completionHandler:nil)
                }))
                alertViewController.addAction(AlertAction.actionWithTitle("Maybe Later", style: .text, handler: nil))
                UIApplication.shared.keyWindow?.rootViewController?.present(alertViewController, animated: true, completion: nil)
            }
        }
    }
}

extension PermissionsManager: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        let category = response.notification.request.content.categoryIdentifier
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
//        let category = notification.request.content.categoryIdentifier
    }

}
