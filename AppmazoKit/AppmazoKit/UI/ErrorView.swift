//
//  ErrorView.swift
//  AppmazoKit
//
//  Created by James Hickman on 5/29/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit

protocol ErrorViewDataSource: class {
    func imageForErrorView(_ errorView: ErrorView) -> UIImage?
    func imageSizeForErrorView(_ errorView: ErrorView) -> CGSize?
    func attributedTitleForErrorView(_ errorView: ErrorView) -> NSAttributedString?
    func attributedDetailsForErrorView(_ errorView: ErrorView) -> NSAttributedString?
    func buttonsForErrorView(_ errorView: ErrorView, alignment: ErrorView.Alignment) -> [UIButton]?

}

public class ErrorView: UIView {
    public enum Alignment {
        case horizontal
        case vertical
    }
    
    weak var dataSource: ErrorViewDataSource?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        initialize()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    private func initialize() {
        let containerView = UIView()
        addSubview(containerView)
        
        let imageView = UIImageView(image: UIImage(named: "logo-a-light", in: Bundle(for: LocationTableViewCell.self), compatibleWith: nil))
        imageView.contentMode = .scaleAspectFit
        containerView.addSubview(imageView)
        
        let titleLabel = UILabel()
        titleLabel.text = "This is a test."
        containerView.addSubview(titleLabel)
        
        let detailsLabel = UILabel()
        detailsLabel.text = "Just testing, nothing to see here. Move along."
        containerView.addSubview(detailsLabel)
        
        let button = Button(style: .filled)
        button.cornerRadius = 4.0
        button.setTitle("Reload", for: .normal)
        containerView.addSubview(button)
        
        let views = ["containerView": containerView,
                     "imageView": imageView,
                     "titleLabel": titleLabel,
                     "detailsLabel": detailsLabel,
                     "button": button]
        let metrics = [String: AnyObject]()
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:[imageView(100)]-16-[titleLabel]-16-[detailsLabel]-16-[button(50)]", options: [.alignAllCenterX], metrics: metrics, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "[button(200)]", options: [.alignAllCenterX], metrics: metrics, views: views))
        
        NSLayoutConstraint(item: containerView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: containerView, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
