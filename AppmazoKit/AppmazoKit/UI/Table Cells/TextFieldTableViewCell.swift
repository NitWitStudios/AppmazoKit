//
//  TextFieldTableViewCell.swift
//  AppmazoKit
//
//  Created by James Hickman on 5/22/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit

public protocol TextFieldTableViewCellDelegate: NSObjectProtocol {
    func textFieldTableViewCell(_ textFieldTableViewCell: TextFieldTableViewCell, didUpdateText text: String?)
    func textFieldTableViewCellDidBeginEditing(_ textFieldTableViewCell: TextFieldTableViewCell)
    func textFieldTableViewCellDidEndEditing(_ textFieldTableViewCell: TextFieldTableViewCell)
}

public class TextFieldTableViewCell: UITableViewCell {
    public weak var delegate : TextFieldTableViewCellDelegate?

    private var promptLabel = UILabel()
    private var textField = UITextField()
    
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
        
        self.selectionStyle = .none
        
        promptLabel.font = UIFont.systemFont(ofSize: 10.0, weight: .regular)
        contentView.addSubview(promptLabel)
        
        textField = UITextField()
        textField.delegate = self
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
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|-[promptLabel(90)]-|", options: [.alignAllLastBaseline], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|-16-[textField]-16-|", options: [.alignAllLastBaseline], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[promptLabel][textField]-|", options: [], metrics: nil, views: views))
    }
}

extension TextFieldTableViewCell: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ sender: UITextField) {
        delegate?.textFieldTableViewCellDidBeginEditing(self)
    }
    
    public func textFieldDidEndEditing(_ sender: UITextField) {
        delegate?.textFieldTableViewCellDidEndEditing(self)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
