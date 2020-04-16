//
//  PermissionsManager+Location.swift
//  AppmazoKit
//
//  Created by James Hickman on 5/13/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import Foundation
import CoreLocation

extension PermissionsManager {
    public static let didUpdateLocationAuthorizationNotificationName = NSNotification.Name(rawValue: "PermissionsManagerDidUpdateLocationAuthorizationName")

    public func requestLocationPermission(_ authorizationStatus: CLAuthorizationStatus) {
        guard CLLocationManager.authorizationStatus() == .notDetermined  else {
            let alertViewController = AlertController.alertControllerWithTitle("Uh-Oh", message: "Looks like you already set the location permissions.\n\nYou can update the authorization in Settings.")
            alertViewController.addAction(AlertAction.actionWithTitle("Go to Settings", style: .filled, handler: { (alertAction) in
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!, options:[:], completionHandler:nil)
            }))
            alertViewController.addAction(AlertAction.actionWithTitle("Maybe Later", style: .normal, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertViewController, animated: true, completion: nil)
            return
        }
        
        if authorizationStatus == .authorizedAlways {
            locationManager.requestAlwaysAuthorization()
        } else if authorizationStatus == .authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    public func isLocationsAuthorized() -> Bool {
        return isLocationAuthorizedWhenInUse() || isLocationAuthorizedAlways()
    }
    
    public func isLocationAuthorizedWhenInUse() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse
    }
    
    public func isLocationAuthorizedAlways() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways
    }
}

extension PermissionsManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        permissionsUpdatedBlock?(.location)
    }
}
