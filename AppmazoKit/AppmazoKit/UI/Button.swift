//
//  Button.swift
//  AppmazoKit
//
//  Created by James Hickman on 5/18/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit

public class Button: UIButton {
    public enum Style {
        case normal
        case filled
        case hollow
    }
    
    public var style: Button.Style
    
    public var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = true
        }
    }
    
    public var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    public var color: UIColor = UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0) {
        didSet {
            update()
        }
    }
    
    public var titleColor: UIColor? {
        didSet {
            update()
        }
    }

    // MARK: - Init
    
    init(style: Button.Style) {
        self.style = style
        
        super.init(frame: CGRect.zero)
        
        update()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.style = .normal
        
        super.init(coder: aDecoder)
    }
    
    // MARK: - UIButton
    
    public override var isHighlighted: Bool {
        willSet {
            if self.isHighlighted != newValue {
                self.transform = newValue ? CGAffineTransform(scaleX: 0.95, y: 0.95) : CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }
    }
    
    // MARK: - Button
    
    private func update() {
        switch style {
        case .normal:
            backgroundColor = UIColor.clear
            setTitleColor(titleColor ?? color, for: .normal)
        case .filled:
            backgroundColor = color
            setTitleColor(titleColor ?? UIColor.white, for: .normal)
        case .hollow:
            backgroundColor = UIColor.clear
            layer.borderWidth = 1.0
            layer.borderColor = color.cgColor
            setTitleColor(titleColor ?? color, for: .normal)
        }
    }
}
