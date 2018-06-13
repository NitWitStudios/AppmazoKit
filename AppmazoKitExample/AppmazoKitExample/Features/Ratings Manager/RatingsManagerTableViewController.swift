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
        case eventCount
        case eventsUntilPrompt
        case lastReminded
        case remindPeriod
        case checkForPrompt
        case count
    }

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        title = "Ratings Manager"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
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
        case Row.eventCount.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: QuantityFormFieldTableViewCell.reuseIdentifier, for: indexPath) as? QuantityFormFieldTableViewCell {
                cell.promptText = "CURRENT EVENT COUNT"
                cell.quantityRange = 1...10
                return cell
            }
        case Row.eventsUntilPrompt.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: QuantityFormFieldTableViewCell.reuseIdentifier, for: indexPath) as? QuantityFormFieldTableViewCell {
                cell.promptText = "REQUIRED EVENT COUNT"
                cell.quantityRange = 1...10
                return cell
            }
        case Row.remindPeriod.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: QuantityFormFieldTableViewCell.reuseIdentifier, for: indexPath) as? QuantityFormFieldTableViewCell {
                cell.promptText = "REMIND IN DAYS"
                cell.quantityRange = 1...10
                return cell
            }
        case Row.checkForPrompt.rawValue:
            if let cell = tableView.dequeueReusableCell(withIdentifier: ButtonTableViewCell.reuseIdentifier, for: indexPath) as? ButtonTableViewCell {
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
        
    }
}
