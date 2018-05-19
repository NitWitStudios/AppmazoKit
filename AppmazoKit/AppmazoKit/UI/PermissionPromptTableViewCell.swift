//
//  PermissionPromptTableViewCell.swift
//  AppmazoKit
//
//  Created by James Hickman on 5/12/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit

public protocol PermissionPromptTableViewCellDelegate: NSObjectProtocol {
    func permissionPromptTableViewCell(_ permissionPromptTableViewCell: PermissionPromptTableViewCell, buttonPressed: Button)
}

public class PermissionPromptTableViewCell: UITableViewCell {
    public enum PermissionType {
        case generic
        case locationAlways
        case locationWhenInUse
        case notifications
    }
    
    public static let reuseIdentifier = "PermissionPromptTableViewCellReuseIdentifier"
    
    public weak var delegate: PermissionPromptTableViewCellDelegate?
    public var permissionType: PermissionType = .generic {
        didSet {
            setupForPermissionType(permissionType)
        }
    }
    
    public var iconImageView: UIImageView!
    public var titleLabel: UILabel!
    public var detailsLabel: UILabel!
    public var button: Button!
    
    public var enabled: Bool = true {
        didSet {
            button.isEnabled = enabled
            button.color = enabled ? enabledColor : disabledColor
        }
    }
    
    public var enabledColor: UIColor = UIColor(red: 3.0/255.0, green: 180.0/255.0, blue: 7.0/255.0, alpha: 1.0) {
        didSet {
            button.color = enabledColor
        }
    }
    
    public var disabledColor: UIColor = UIColor(red: 96.0/255.0, green: 96.0/255.0, blue: 96.0/255.0, alpha: 1.0) {
        didSet {
            button.color = disabledColor
        }
    }
    
    // MARK: - Init
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = UIColor(red: 96.0/255.0, green: 96.0/255.0, blue: 96.0/255.0, alpha: 1.0)
        self.contentView.addSubview(iconImageView)
        
        titleLabel = UILabel()
        titleLabel.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(titleLabel)
        
        detailsLabel = UILabel()
        detailsLabel.font = UIFont.systemFont(ofSize: 14.0)
        detailsLabel.numberOfLines = 0
        self.contentView.addSubview(detailsLabel)
        
        button = Button(style: .filled)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        button.layer.cornerRadius = 4.0
        button.clipsToBounds = true
        button.setTitle("Enable", for: .normal)
        button.setTitle("Enabled", for: .disabled)
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        
        let views: [String : UIView] = [ "iconImageView" : iconImageView,
                                         "titleLabel" : titleLabel,
                                         "detailsLabel" : detailsLabel,
                                         "button" : button ]
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|-[iconImageView(30)]-[titleLabel]-16-[button(80)]-16-|", options: [.alignAllCenterY], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|-30-[detailsLabel]-16-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[iconImageView(30)]-[detailsLabel]", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[titleLabel(30)]-[detailsLabel]", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[button(30)]-[detailsLabel]", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[detailsLabel]-|", options: [], metrics: nil, views: views))
    }
    
    // MARK: - PDPermissionPromptTableViewCell
    
    private func setupForPermissionType(_ permissionType: PermissionType) {
        switch permissionType {
        case .locationAlways:
            iconImageView.image = UIImage(named: "icon-pin", in: Bundle(for: LocationTableViewCell.self), compatibleWith: nil)
            titleLabel.text = "Location - Always"
            detailsLabel.text = "We would like to use your location all the time so we can better locate you!"
        case .locationWhenInUse:
            iconImageView.image = UIImage(named: "icon-pin", in: Bundle(for: LocationTableViewCell.self), compatibleWith: nil)
            titleLabel.text = "Location - When In Use"
            detailsLabel.text = "We would like to use your location while you use the app so we can better locate you!"
        case .notifications:
            iconImageView.image = UIImage(named: "icon-bell", in: Bundle(for: LocationTableViewCell.self), compatibleWith: nil)
            titleLabel.text = "Push Notifications"
            detailsLabel.text = "We would like to send you push notifications to keep you up to date."
        default:
            break
        }
    }
    
    @objc func buttonPressed(_ sender: Button) {
        delegate?.permissionPromptTableViewCell(self, buttonPressed: sender)
    }
}
