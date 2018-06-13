//
//  ButtonTableViewCell.swift
//  AppmazoKit
//
//  Created by James Hickman on 6/12/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit

public class ButtonTableViewCell: UITableViewCell {
    public let button = Button(style: .filled)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        button.setTitle("Click Me", for: .normal)
        button.backgroundColor = UIColor.appmazoDarkOrange
        button.cornerRadius = 4.0
        contentView.addSubview(button)
        
        let views: [String : UIView] = ["button" : button]
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|-16-[button]-16-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[button(50)]-|", options: [], metrics: nil, views: views))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
