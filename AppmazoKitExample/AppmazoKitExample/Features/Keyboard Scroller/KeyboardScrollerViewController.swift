//
//  KeyboardScrollerViewController.swift
//  AppmazoKitExample
//
//  Created by James Hickman on 5/19/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit
import AppmazoKit

class KeyboardScrollerViewController: UIViewController, Storyboardable {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: Button!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "Keyboard Scroller"
        scrollView.automaticallytAdjustsInsetsForKeyboard = true
        
        loginButton.style = .filled
        loginButton.color = UIColor(red: 3.0/255.0, green: 180.0/255.0, blue: 7.0/255.0, alpha: 1.0)
        loginButton.cornerRadius = 4.0
    }
    
    @IBAction func tapGestureRecognizerTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - KeyboardScrollerViewController

    @IBAction func loginButtonPressed(_ sender: Button) {
        guard let email = emailTextField.text, email.count > 0 else {
            emailTextField.shake()
            return
        }
        
        guard let password = passwordTextField.text, password.count > 0 else {
            passwordTextField.shake()
            return
        }
    }
}
