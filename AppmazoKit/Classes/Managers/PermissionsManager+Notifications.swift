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
        #else
        return false
        #endif
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
            DispatchQueue.main.async {
                if granted {
                    #if targetEnvironment(simulator)
                    self?.enableNotificationsForSimulators()
                    #endif
                    
                    let viewAction = UNNotificationAction(identifier: "view", title: "View", options: [.foreground])
                    let defaultCategory = UNNotificationCategory(identifier: "defaultCategory", actions: [viewAction], intentIdentifiers: [], options: [])
                    
                    UNUserNotificationCenter.current().setNotificationCategories([defaultCategory])
                    UIApplication.shared.registerForRemoteNotifications()
                    self?.permissionsUpdatedBlock?(.notifications)
                } else if let error = error {
                    let alertViewController = AlertController.alertControllerWithTitle("Uh-Oh", message: error.localizedDescription)
                    alertViewController.addAction(AlertAction.actionWithTitle("Dismiss", style: .filled, handler: nil))
                    UIApplication.shared.keyWindow?.rootViewController?.present(alertViewController, animated: true, completion: nil)
                } else {
                    let alertViewController = AlertController.alertControllerWithTitle("Uh-Oh", message: "Looks like you previously set notifications authorization for our app.\nPlease visit the Settings App and change the notifications permissions there.")
                    alertViewController.addAction(AlertAction.actionWithTitle("Go to Settings", style: .filled, handler: { (alertAction) in
                        UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!, options:[:], completionHandler:nil)
                    }))
                    alertViewController.addAction(AlertAction.actionWithTitle("Maybe Later", style: .normal, handler: nil))
                    UIApplication.shared.keyWindow?.rootViewController?.present(alertViewController, animated: true, completion: nil)
                }
            }
        }
    }
}

extension PermissionsManager: UIApplicationDelegate {
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // TODO: Notify of successful authorization...
    }
    
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // TODO: Notify of failed authorization...
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
