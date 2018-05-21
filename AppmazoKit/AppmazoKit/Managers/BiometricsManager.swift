//
//  BiometricsManager.swift
//  AppmazoKit
//
//  Created by James Hickman on 5/20/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import Foundation
import LocalAuthentication

public class BiometricsManager: NSObject {
    private struct KeychainConfiguration {
        static let serviceName = "Password"
        static let accessGroup: String? = nil
    }
    
    private var passwordItems: [KeychainPasswordItem] = []
    
    /**
     Get the current device's available biometry type.
     
     - returns: Available biometry type.
     */
    public func availableBiometrics() -> LABiometryType? {
        let localAuthContext = LAContext()
        var error: NSError?
        if localAuthContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return localAuthContext.biometryType
        }
        return nil
    }
    
    /**
     Check if the device supports FaceID.
     
     - returns: true if device supports FaceID.
     */
    public func isFaceIDAvailable() -> Bool {
        return availableBiometrics() == .faceID
    }
    
    /**
     Check if the device supports TouchID.
     
     - returns: true if device supports TouchID.
     */
    public func isTouchIDAvailable() -> Bool {
        return availableBiometrics() == .touchID
    }
    
    /**
     Attempts to verify a user using biometrics. If user has not yet verified, it will present OS authorization request.
     
     - parameter completion: The result of the verification is passed back to the caller along with an error if one occurred.
     */
    public func verifyUserWithBiometrics(_ completion: @escaping (Bool, LAError?) -> Void) {
        let localAuthContext = LAContext()
        localAuthContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To verify your identity.") { (success, error) in
            if let error = error as NSError? {
                let laError = LAError(_nsError: error)
                completion(success, laError)
            } else {
                completion(success, nil)
            }
        }
    }
    
    /**
     Save the password to the device's keychain.
     
     - returns: true if the password was saved successfully.
     */
    public func savePassword(_ password: String, forUser user: String) -> Bool {
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: user, accessGroup: KeychainConfiguration.accessGroup)
            try passwordItem.savePassword(password)
            return true
        } catch let error {
            print("Error: \(error)")
            return false
        }
    }
    
    /**
     Delete the password from the device's keychain.
     
     - returns: true if the password was deleted successfully.
     */
    public func deletePassword(forUser user: String) -> Bool {
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: user, accessGroup: KeychainConfiguration.accessGroup)
            try passwordItem.deleteItem()
            return true
        } catch let error {
            print("Error: \(error)")
            return false
        }
    }
    
    /**
     Retrieve the password from the device's keychain.
     
     - parameter user: The user the password is associated with.
     - returns: The retrieved password.
     */
    public func retrievePassword(forUser user: String) -> String? {
        do {
            let passwordItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName, account: user, accessGroup: KeychainConfiguration.accessGroup)
            let keychainPassword = try passwordItem.readPassword()
            return keychainPassword
        } catch {
            return nil
        }
    }
}
