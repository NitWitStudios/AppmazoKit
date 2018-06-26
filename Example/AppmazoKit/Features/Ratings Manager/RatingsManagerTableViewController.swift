//
//  RatingsManagerTableViewController.swift
//  AppmazoKitExample
//
//  Created by James Hickman on 6/12/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit
import AppmazoKit

class RatingsManagerTableViewController: UITableViewController, Storyboardable {
    private enum Section: Int {
        case main
        case count
    }
    
    private enum Row: Int {
        case isVersionRated
        case currentEventCount
        case requiredEventCount
        case datePrompted
        case daysToPrompt
        case checkForPrompt
        case count
    }

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "Ratings Manager"
        
        RatingsManager.reset()
        RatingsManager.requiredEventCount = 5
        RatingsManager.daysToPrompt = 2
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        tableView.register(FormFieldTableViewCell.self, forCellReuseIdentifier: FormFieldTableViewCell.reuseIdentifier)
        tableView.register(TextFormFieldTableViewCell.self, forCellReuseIdentifier: TextFormFieldTableViewCell.reuseIdentifier)
        tableView.register(DateFormFieldTableViewCell.self, forCellReuseIdentifier: DateFormFieldTableViewCell.reuseIdentifier)
        tableView.register(QuantityFormFieldTableViewCell.self, forCellReuseIdentifier: QuantityFormFieldTableViewCell.reuseIdentifier)
        tableView.register(ButtonTableViewCell.self, forCellReuseIdentifier: ButtonTableViewCell.reuseIdentifier)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case Row.isVersionRated.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TextFormFieldTableViewCell.reuseIdentifier, for: indexPath) as? TextFormFieldTableViewCell {
                cell.promptText = "IS THIS VERSION RATED?"
                cell.textField.text = RatingsManager.isVersionRated ? "Yes" : "No"
                return cell
            }
        case Row.currentEventCount.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: QuantityFormFieldTableViewCell.reuseIdentifier, for: indexPath) as? QuantityFormFieldTableViewCell {
                cell.delegate = self
                cell.promptText = "CURRENT EVENT COUNT"
                cell.quantity = RatingsManager.currentEventCount
                cell.quantityRange = 1...10
                return cell
            }
        case Row.requiredEventCount.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: QuantityFormFieldTableViewCell.reuseIdentifier, for: indexPath) as? QuantityFormFieldTableViewCell {
                cell.delegate = self
                cell.promptText = "REQUIRED EVENT COUNT"
                cell.quantity = RatingsManager.requiredEventCount
                cell.quantityRange = 1...10
                return cell
            }
        case Row.datePrompted.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: TextFormFieldTableViewCell.reuseIdentifier, for: indexPath) as? TextFormFieldTableViewCell {
                cell.promptText = "LAST PROMPTED"
                cell.textField.text = RatingsManager.datePrompted != nil ? RatingsManager.datePrompted?.convertToString() : "Not Yet Reminded"
                cell.textField.isUserInteractionEnabled = false
                return cell
            }
        case Row.daysToPrompt.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: QuantityFormFieldTableViewCell.reuseIdentifier, for: indexPath) as? QuantityFormFieldTableViewCell {
                cell.delegate = self
                cell.promptText = "DAYS TO PROMPT"
                cell.quantity = RatingsManager.daysToPrompt
                cell.quantityRange = 0...10
                return cell
            }
        case Row.checkForPrompt.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.reuseIdentifier, for: indexPath) as? ButtonTableViewCell {
                cell.delegate = self
                cell.button.setTitle("Check for Ratings Prompt", for: .normal)
                cell.button.backgroundColor = UIColor.appmazoDarkOrange
                return cell
            }
        default:
            break
        }
        return tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
    }
}

extension RatingsManagerTableViewController: QuantityFormFieldTableViewCellDelegate {
    func quantityFormFieldTableViewCell(_ quantityFormFieldTableViewCell: QuantityFormFieldTableViewCell, didFinishPickingValue value: Int) {
        guard let indexPath = tableView.indexPath(for: quantityFormFieldTableViewCell) else { return }
        
        switch indexPath.row {
        case Row.currentEventCount.rawValue:
            RatingsManager.currentEventCount = value
        case Row.requiredEventCount.rawValue:
            RatingsManager.requiredEventCount = value
        case Row.daysToPrompt.rawValue:
            RatingsManager.daysToPrompt = value
        default:
            break
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension RatingsManagerTableViewController: ButtonTableViewCellDelegate {
    func buttonTableViewCell(_ buttonTableViewCell: ButtonTableViewCell, buttonPressed: Button) {
        RatingsManager.currentEventCount = RatingsManager.currentEventCount + 1

        if RatingsManager.shouldPromptForRating() {
            RatingsManager.promptForRating()
            RatingsManager.currentEventCount = 0
        }
        
        tableView.reloadData()
    }
}
