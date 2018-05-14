//
//  PermissionsManager.swift
//  AppmazoKit
//
//  Created by James Hickman on 5/13/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import Foundation
import CoreLocation

public class PermissionsManager: NSObject {
    public enum PermissionType {
        case location
        case notifications
        case biometrics
        case camera
        case microphone
    }
    
    internal let locationManager = CLLocationManager()
    
    public var permissionsUpdatedBlock: ((PermissionType) -> Void)?
    
    // MARK: - PermissionsManager
    
    public override init() {
        super.init()
        
        locationManager.delegate = self
    }
}
