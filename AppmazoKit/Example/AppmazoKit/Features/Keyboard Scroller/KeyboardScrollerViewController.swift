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
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "Keyboard Scroller"
        
        view.backgroundColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        scrollView.automaticallytAdjustsInsetsForKeyboard = true
    }
    
    @IBAction func tapGestureRecognizerTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
