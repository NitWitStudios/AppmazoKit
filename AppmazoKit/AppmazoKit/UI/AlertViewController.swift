//
//  AlertViewController.swift
//  AppmazoKit
//
//  Created by James Hickman on 5/13/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit

public class AlertViewController: UIViewController, AlertActionDelegate {
    private var modalTransitioning: ModalTransitioning!
    
    private var containerView: UIView!
    private var customView: UIView?
    private var imageView: UIImageView?
    private var messageLabel: UILabel?
    
    private var titleText: String?
    private var message: String?
    private var attributedMessage: NSAttributedString?
    
    var image: UIImage?
    var imageTintColor: UIColor?
    
    var actions = [AlertAction]()
    
    // MARK: - Init
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func alertControllerWithTitle(_ title: String, message: String) -> AlertViewController {
        return AlertViewController(withTitle: title, message: message, attributedMessage: nil, customView: nil)
    }
    
    class func alertControllerWithTitle(_ title: String, attributedMessage: NSAttributedString) -> AlertViewController {
        return AlertViewController(withTitle: title, message: nil, attributedMessage: attributedMessage, customView: nil)
    }
    
    class func alertControllerWithCustomView(_ customView: UIView) -> AlertViewController {
        return AlertViewController(withTitle: nil, message: nil, attributedMessage: nil, customView: customView)
    }
    
    init(withTitle title: String?, message: String?, attributedMessage: NSAttributedString?, customView: UIView?) {
        super.init(nibName: nil, bundle: nil)
        
        self.titleText = title
        self.message = message
        self.attributedMessage = attributedMessage
        self.customView = customView
        
        self.modalTransitioning = ModalTransitioning()
        self.transitioningDelegate = self.modalTransitioning
        self.modalPresentationStyle = .overFullScreen
    }
    
    // MARK: - UIViewController
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.borderWidth = 1.0
        containerView.layer.cornerRadius = 3.0
        containerView.clipsToBounds = true
        self.view.addSubview(containerView)
        self.containerView = containerView
        
        let views = [
            "containerView": containerView
        ]
        let metrics = [String: AnyObject]()
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let portraitWidth = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        if UIDevice.current.userInterfaceIdiom == .pad || portraitWidth == 414.0 {
            // iPad / iPhone 7+
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "[containerView(382)]", options: [], metrics: metrics, views: views))
        } else if portraitWidth == 375.0 {
            // iPhone 7
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "[containerView(343)]", options: [], metrics: metrics, views: views))
        } else {
            // iPhone 4/5
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "[containerView(288)]", options: [], metrics: metrics, views: views))
        }
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=8)-[containerView]-(>=8)-|", options: [], metrics: metrics, views: views))
        
        NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        
        if customView != nil {
            setupCustomAlert()
        } else {
            setupStandardAlert()
        }
        
        addActionConstraints()
    }
    
    // MARK: - AlertViewController
    
    private func setupStandardAlert() {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        containerView.addSubview(imageView)
        self.imageView = imageView
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        titleLabel.text = titleText
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        containerView.addSubview(titleLabel)
        
        let messageLabel = UILabel()
        messageLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        messageLabel.textColor = UIColor.black
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        containerView.addSubview(messageLabel)
        self.messageLabel = messageLabel
        
        let views = [
            "imageView": imageView,
            "titleLabel": titleLabel,
            "messageLabel": messageLabel
        ]
        let metrics = [String: AnyObject]()
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleLabel]-16-[messageLabel]", options: [.alignAllCenterX], metrics: metrics, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "[imageView]", options: [], metrics: metrics, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|-16-[titleLabel]-16-|", options: [], metrics: metrics, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|-16-[messageLabel]-16-|", options: [], metrics: metrics, views: views))
        
        if image != nil {
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-24-[imageView]-16-[titleLabel]", options: [.alignAllCenterX], metrics: metrics, views: views))
        } else {
            NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-24-[titleLabel]", options: [], metrics: metrics, views: views))
        }
        
        if attributedMessage != nil {
            messageLabel.attributedText = attributedMessage
        } else {
            messageLabel.text = message
        }
        
        if imageTintColor != nil {
            imageView.image = image?.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = imageTintColor
        }
    }
    
    private func setupCustomAlert() {
        guard let customView = customView else {
            return
        }
        
        self.containerView.addSubview(customView)
        
        let views = [
            "customView": customView
        ]
        let metrics = [String: AnyObject]()
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|[customView]", options: [], metrics: metrics, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|[customView]|", options: [], metrics: metrics, views: views))
    }
    
    private func addActionConstraints() {
        var previousAction: UIButton?
        for (index, action) in actions.enumerated() {
            action.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(action)
            
            let actionLeftConstraint = NSLayoutConstraint(item: action, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1.0, constant: 16.0)
            actionLeftConstraint.isActive = true
            
            let actionRightConstraint = NSLayoutConstraint(item: action, attribute: .left, relatedBy: .equal, toItem: containerView, attribute: .left, multiplier: 1.0, constant: 16.0)
            actionRightConstraint.isActive = true
            
            let actionHeightConstraint = NSLayoutConstraint(item: action, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0)
            actionHeightConstraint.isActive = true
            
            let actionHorizontalConstraint = NSLayoutConstraint(item: action, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            actionHorizontalConstraint.isActive = true
            
            if index == 0 { // Top Action
                let toItem = customView != nil ? customView : messageLabel
                let actionTopConstraint = NSLayoutConstraint(item: action, attribute: .top, relatedBy: .equal, toItem: toItem, attribute: .bottom, multiplier: 1.0, constant: 24.0)
                actionTopConstraint.isActive = true
            } else {
                let actionTopConstraint = NSLayoutConstraint(item: action, attribute: .top, relatedBy: .equal, toItem: previousAction, attribute: .bottom, multiplier: 1.0, constant: 8.0)
                actionTopConstraint.isActive = true
            }
            
            if index == actions.count - 1 { // Bottom Action
                let actionBottomConstraint = NSLayoutConstraint(item: action, attribute: .bottom, relatedBy: .equal, toItem: containerView, attribute: .bottom, multiplier: 1.0, constant: -16.0)
                actionBottomConstraint.isActive = true
            }
            
            previousAction = action
        }
    }
    
    public func addAction(_ action: AlertAction) {
        action.delegate = self
        actions.append(action)
    }
    
    // MARK: EBUIAlertActionDelegate
    
    func alertActionPressed(_ alertAction: AlertAction) {
        self.dismiss(animated: true, completion: nil)
    }
}

public class AlertAction: UIButton {
    private var style: AlertActionStyle!
    private var handler: ((AlertAction) -> Void)?
    
    fileprivate weak var delegate: AlertActionDelegate?
    
    // MARK: Init
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(withTitle title: String, style: AlertActionStyle, handler: ((AlertAction) -> Void)?) {
        super.init(frame: CGRect.zero)
        
        self.style = style
        self.handler = handler
        
        titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        setTitle(title, for: .normal)
        addTarget(self, action: #selector(actionPressed(_:)), for: .touchUpInside)
        
        switch style {
        case .button:
            backgroundColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
            setTitleColor(UIColor.white, for: .normal)
        case .text:
            backgroundColor = UIColor.clear
            setTitleColor(UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0), for: .normal)
        }
    }
    
    // MARK: EBUIAlertAction
    
    class func actionWithTitle(_ title: String, style: AlertActionStyle, handler: ((AlertAction) -> Void)?) -> AlertAction {
        return AlertAction(withTitle: title, style: style, handler: handler)
    }
    
    @objc private func actionPressed(_ sender: AlertAction) {
        delegate?.alertActionPressed(self)
        handler?(sender)
    }
}

private protocol AlertActionDelegate: AnyObject {
    func alertActionPressed(_ alertAction: AlertAction)
}

public enum AlertActionStyle: Int {
    case button
    case text
}
