//
//  URLValidationViewController.swift
//  AppmazoKitExample
//
//  Created by James Hickman on 5/29/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit
import WebKit
import AppmazoKit

class URLValidationViewController: UIViewController, Storyboardable {
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressViewHeightConstraint: NSLayoutConstraint!
    
    private let imageViewSize = CGSize(width: 40.0, height: 40.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "URL Validation"
        
        progressView.tintColor = UIColor.appmazoDarkOrange
        progressViewHeightConstraint.constant = 0.0

        webView.navigationDelegate = self
        webView.isHidden = true
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)

        textField.delegate = self
        textField.keyboardType = .URL
        textField.returnKeyType = .go
        textField.autocorrectionType = .no
        textField.clearButtonMode = .whileEditing
        
        imageView.isHidden = true
        imageViewWidthConstraint.constant = 0.0
    }
    
    func showValidURL(_ url: URL) {
        imageViewWidthConstraint.constant = imageViewSize.width
        progressViewHeightConstraint.constant = 0.0
        
        webView.isHidden = false
        imageView.isHidden = false

        imageView.image = UIImage(named: "icon-checkmark-circle")
        imageView.tintColor = UIColor.appmazoSuccessGreen
        
        webView.load(URLRequest(url: url))
    }
    
    func showInvalidURL() {
        imageViewWidthConstraint.constant = imageViewSize.width
        progressViewHeightConstraint.constant = 0.0
        
        webView.isHidden = true
        imageView.isHidden = false
        
        imageView.image = UIImage(named: "icon-x-circle")
        imageView.tintColor = UIColor.appmazoErrorRed
        
        detailsLabel.text = "Oops! Looks like thats not a valid URL."
    }
    
    @objc private func enterURLButtonPressed(_ sender: Button) {
        textField.becomeFirstResponder()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if (keyPath == "estimatedProgress") { // listen to changes and updated view
            progressView.setProgress(Float(webView.estimatedProgress), animated: false)
            if webView.estimatedProgress == 1 {
                progressViewHeightConstraint.constant = 0.0
            } else {
                progressViewHeightConstraint.constant = 2.0
            }
        }
    }
}

extension URLValidationViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        imageViewWidthConstraint.constant = 0.0
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        imageView.isHidden = true
        imageViewWidthConstraint.constant = 0.0

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        imageViewWidthConstraint.constant = imageViewSize.width
        imageView.replaceWithActivityIndicator(activityIndicatorStyle: .gray)
        
        if let text = textField.text, var url = URL(string: text) {
            url.isValid { [weak self] (valid) in
                DispatchQueue.main.async {
                    self?.imageView.hideActivityIndicator()
                    if valid {
                        self?.showValidURL(url)
                    } else {
                        self?.showInvalidURL()
                    }
                }
            }
        } else {
            showInvalidURL()
        }
        
        return true
    }
}

extension URLValidationViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.performDefaultHandling, nil)
    }
}
