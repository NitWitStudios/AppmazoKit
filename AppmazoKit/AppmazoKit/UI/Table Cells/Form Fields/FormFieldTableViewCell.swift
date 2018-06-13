//
//  FormFieldTableViewCell.swift
//  AppmazoKit
//
//  Created by James Hickman on 6/12/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit

public class FormFieldTableViewCell: UITableViewCell {
    private var promptLabel = UILabel()
    var textField = UITextField()
    
    public var promptText: String? {
        didSet {
            promptLabel.text = promptText
        }
    }
    
    public var placeholderText: String? {
        didSet {
            textField.placeholder = placeholderText
        }
    }
    
    public var textFieldText: String? {
        didSet {
            textField.text = textFieldText
        }
    }
    
    // MARK: - Init
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        promptLabel.font = UIFont.systemFont(ofSize: 10.0, weight: .regular)
        contentView.addSubview(promptLabel)
        
        textField = UITextField()
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.adjustsFontSizeToFitWidth = true
        contentView.addSubview(textField)
        
        let views: [String : UIView] = [ "textField" : textField,
                                         "promptLabel": promptLabel]
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|-[promptLabel]-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|-16-[textField]-16-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[promptLabel][textField]-|", options: [], metrics: nil, views: views))
    }
}
