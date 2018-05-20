//
//  AlertControllerTableViewController.swift
//  AppmazoKitExample
//
//  Created by James Hickman on 5/18/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit
import AppmazoKit

class AlertControllerTableViewController: UITableViewController, Storyboardable {
    private let UITableViewCellReuseIdentifier = "UITableViewCellReuseIdentifier"
    
    private enum Section: Int {
        case alerts
        case count
    }
    
    private enum Row: Int {
        case singleButton
        case doubleButtonWithImage
        case tripleButton
        case count
    }
    
    // MARK: - UITableViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Alert Controllers"
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCellReuseIdentifier)
    }
    
    // MARK: - AlertControllerTableViewController
    
    private func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
        switch indexPath.row {
        case Row.singleButton.rawValue:
            return "Single Button"
        case Row.doubleButtonWithImage.rawValue:
            return "Double Button with Image"
        case Row.tripleButton.rawValue:
            return "Triple Button"
        default:
            return nil
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCellReuseIdentifier, for: indexPath)
        
        cell.textLabel?.text = titleForRowAtIndexPath(indexPath)

        return cell
    }
    
    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var title = ""
        var message = ""
        var image: UIImage?
        var alertActions = [AlertAction]()
        
        switch indexPath.row {
        case Row.singleButton.rawValue:
            title = "Single Button Alert"
            message = "This is a simple alert that gives the user a single CTA."
            alertActions.append(AlertAction(withTitle: "Dismiss", style: .filled, handler: nil))
        case Row.doubleButtonWithImage.rawValue:
            image = UIImage(named: "icon-radioactive")
            title = "Double Button with Image Alert"
            message = "This alert has an image and two CTAs with different styles."
            alertActions.append(AlertAction(withTitle: "Whoa!", style: .filled, handler: nil))
            alertActions.append(AlertAction(withTitle: "Dismiss", style: .normal, handler: nil))
        case Row.tripleButton.rawValue:
            title = "Triple Button Alert"
            message = "This alert has three CTAs with different styles."
            let coloredAlertAction = AlertAction(withTitle: "Whoa!", style: .filled, handler: nil)
            coloredAlertAction.color = UIColor.appmazoLightOrange
            alertActions.append(coloredAlertAction)
            alertActions.append(AlertAction(withTitle: "Cool!", style: .hollow, handler: nil))
            alertActions.append(AlertAction(withTitle: "Dismiss", style: .normal, handler: nil))
        default:
            break
        }
        
        let alertController = AlertController.alertControllerWithTitle(title, message: message)
        alertController.image = image
        alertController.addActions(alertActions)
        present(alertController, animated: true, completion: nil)
    }
}
