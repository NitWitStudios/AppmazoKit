//
//  BiometricsViewController.swift
//  AppmazoKitExample
//
//  Created by James Hickman on 5/20/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit
import AppmazoKit
import LocalAuthentication

class BiometricsViewController: UIViewController, Storyboardable {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verifyButton: Button!
    
    @IBOutlet weak var resetCredentialsButton: Button!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    private let permissionsManager = PermissionsManager()
    private let biometricsManager = BiometricsManager()
    
    private let user = "demo@appmazo.com"
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Biometrics"
        
        view.backgroundColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        scrollView.automaticallytAdjustsInsetsForKeyboard = true
        
        emailTextField.text = user
        emailTextField.isUserInteractionEnabled = false
        
        verifyButton.style = .filled
        verifyButton.color = UIColor.appmazoLightOrange
        verifyButton.cornerRadius = 4.0
        
        updatePrompt()
        updateButtons()
        verify()
    }
    
    private func updatePrompt() {
        if biometricsManager.retrievePassword(forUser: user) != nil {
            promptLabel.text = "Verify with biometrics."
        } else {
            promptLabel.text = "Save your credentials before biometric verification."
        }
    }

    private func updateButtons() {
        resetCredentialsButton.isHidden = true

        if biometricsManager.retrievePassword(forUser: user) != nil {
            verifyButton.setTitle("Verify", for: .normal)
            resetCredentialsButton.isHidden = false
        } else {
            verifyButton.setTitle("Save", for: .normal)
        }
    }

    private func verify() {
        verifyButton.replaceWithActivityIndicator(activityIndicatorStyle: .whiteLarge)
        resetCredentialsButton.isHidden = true
        
        if let password = biometricsManager.retrievePassword(forUser: user) {
            // Password stored, attempt to verify with biometrics.
            biometricsManager.verifyUserWithBiometrics { [weak self] (success, error) in
                DispatchQueue.main.async {
                    if success {
                        self?.promptLabel.text = "Success! Your credentials were loaded through biometric verification."
                        self?.passwordTextField.text = password
                    } else if error?.code == LAError.biometryNotEnrolled {
                        self?.promptLabel.text = "Oops! Looks like there aren't any enrolled biometrics on this device yet. Try adding some in the iOS Settings app."
                    } else if error?.code == LAError.biometryNotAvailable {
                        self?.promptLabel.text = "Oops! Looks like this device doesn't support biometrics."
                    } else if error?.code == LAError.biometryLockout {
                        self?.promptLabel.text = "Oops! Looks like there were too many failed attempts. Try locking then unlocking the device to disable biometrics lockout."
                    } else if error != nil && error?.code != LAError.userCancel {
                        self?.promptLabel.text = "Oops! Looks like there was a problem verifying you with biometrics. Please try again."
                    }
                    self?.verifyButton.hideActivityIndicator()
                    self?.updateButtons()
                }
            }
        } else if let password = passwordTextField.text, password.count > 0 {
            // User is saving a password
            if biometricsManager.savePassword(password, forUser: user) {
                promptLabel.text = "Password saved! Now try verifying."
                passwordTextField.text = nil
                view.endEditing(true)
            } else {
                promptLabel.text = "Oops! Looks like there was a problem saving your password."
            }
            verifyButton.hideActivityIndicator()
            updateButtons()
        } else {
            verifyButton.hideActivityIndicator()
            updateButtons()
        }
    }

    @IBAction func tapGestureRecognizerTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - BiometricsViewController
    
    @IBAction func verifyButtonPressed(_ sender: Button) {
        guard let password = passwordTextField.text, password.count > 0 || biometricsManager.retrievePassword(forUser: user) != nil else {
            passwordTextField.shake()
            return
        }
        
        promptLabel.text = nil
        verify()
    }
    
    @IBAction func resetCredentialsButtonPressed(_ sender: Button) {
        passwordTextField.text = nil
        if biometricsManager.deletePassword(forUser: user) {
            updatePrompt()
            updateButtons()
        } else {
            promptLabel.text = "Oops! Looks like there was a problem deleting the saved credentials."
        }
    }
}
