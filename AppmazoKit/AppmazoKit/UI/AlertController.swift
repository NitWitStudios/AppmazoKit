//
//  AlertController.swift
//  AppmazoKit
//
//  Created by James Hickman on 5/13/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit

public class AlertController: UIViewController {
    private var modalTransitioning = ModalTransitioning()
    
    private var containerView = UIView()
    private var imageView = UIImageView()
    private var titleLabel = UILabel()
    private var messageLabel = UILabel()
    private var customView: UIView?

    private var titleText: String?
    private var message: String?
    private var attributedMessage: NSAttributedString?
    
    public var image: UIImage?
    public var imageTintColor: UIColor?
    
    private var actions = [AlertAction]()
    
    public var modalBackgroundStyle: ModalTransitioning.BackgroundStyle = .clear {
        didSet {
            modalTransitioning.backgroundStyle = modalBackgroundStyle
            if modalBackgroundStyle == .clear {
                addShadow()
            }
        }
    }
    
    public var showsShadow: Bool = false {
        didSet {
            showsShadow ? addShadow() : removeShadow()
        }
    }
    
    // MARK: - Init
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public class func alertControllerWithTitle(_ title: String, message: String) -> AlertController {
        return AlertController(withTitle: title, message: message, attributedMessage: nil, customView: nil)
    }
    
    public class func alertControllerWithTitle(_ title: String, attributedMessage: NSAttributedString) -> AlertController {
        return AlertController(withTitle: title, message: nil, attributedMessage: attributedMessage, customView: nil)
    }
    
    public class func alertControllerWithCustomView(_ customView: UIView) -> AlertController {
        return AlertController(withTitle: nil, message: nil, attributedMessage: nil, customView: customView)
    }
    
    init(withTitle title: String?, message: String?, attributedMessage: NSAttributedString?, customView: UIView?) {
        super.init(nibName: nil, bundle: nil)
        
        self.titleText = title
        self.message = message
        self.attributedMessage = attributedMessage
        self.customView = customView
        
        transitioningDelegate = modalTransitioning
        modalPresentationStyle = .overFullScreen
    }
    
    // MARK: - UIViewController
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.backgroundColor = UIColor.white
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.borderWidth = 1.0
        containerView.layer.cornerRadius = 3.0
        view.addSubview(containerView)
        
        let views = ["containerView": containerView]
        let metrics = ["modalWidth": UIScreen.main.modalWidth()]
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "[containerView(modalWidth)]", options: [], metrics: metrics, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=8)-[containerView]-(>=8)-|", options: [], metrics: metrics, views: views))
        
        NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        
        if customView != nil {
            setupCustomAlert()
        } else {
            setupStandardAlert()
        }
        
        addActionConstraints()
    }
    
    // MARK: - AlertController
    
    public func addAction(_ action: AlertAction) {
        action.delegate = self
        actions.append(action)
    }
    
    public func addActions(_ actions: [AlertAction]) {
        for action in actions {
            action.delegate = self
            self.actions.append(action)
        }
    }

    private func setupStandardAlert() {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        containerView.addSubview(imageView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        titleLabel.text = titleText
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        containerView.addSubview(titleLabel)
        
        messageLabel = UILabel()
        messageLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
        messageLabel.textColor = UIColor.black
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        containerView.addSubview(messageLabel)
        
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
        
        containerView.addSubview(customView)
        
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
        var previousAction: Button?
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
    
    private func addShadow() {
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOpacity = 0.8
        containerView.layer.shadowRadius = 5.0
        containerView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    }
    
    private func removeShadow() {
        containerView.layer.shadowColor = UIColor.clear.cgColor
        containerView.layer.shadowOpacity = 0.0
        containerView.layer.shadowRadius = 0.0
        containerView.layer.shadowOffset = CGSize.zero
    }
}

extension AlertController: AlertActionDelegate {
    func alertActionPressed(_ alertAction: AlertAction) {
        dismiss(animated: true, completion: {
            alertAction.handler?(alertAction)
        })
    }
}

public class AlertAction: Button {
    fileprivate var handler: ((AlertAction) -> Void)?
    
    fileprivate weak var delegate: AlertActionDelegate?
    
    // MARK: Init
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(withTitle title: String, style: AlertAction.Style, handler: ((AlertAction) -> Void)?) {
        super.init(style: style)
        
        self.handler = handler
        
        cornerRadius = 4.0
        titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        
        setTitle(title, for: .normal)
        addTarget(self, action: #selector(actionPressed(_:)), for: .touchUpInside)
    }
    
    // MARK: AlertAction
    
    class func actionWithTitle(_ title: String, style: AlertAction.Style, handler: ((AlertAction) -> Void)?) -> AlertAction {
        return AlertAction(withTitle: title, style: style, handler: handler)
    }
    
    @objc private func actionPressed(_ sender: AlertAction) {
        delegate?.alertActionPressed(self)
    }
}

private protocol AlertActionDelegate: AnyObject {
    func alertActionPressed(_ alertAction: AlertAction)
}
