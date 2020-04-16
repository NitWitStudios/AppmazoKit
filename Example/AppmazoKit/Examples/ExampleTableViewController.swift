//
//  ExampleTableViewController.swift
//  AppmazoKit
//
//  Created by James Hickman on 5/12/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit
import AppmazoKit

class ExampleTableViewController: UITableViewController, Storyboardable {
    private enum Section: Int {
        case managers
        case ui
        case extensions
        case count
    }
    
    private enum ManagersRow: Int {
        case permissions
        case location
        case biometrics
        case ratings
        case count
    }

    private enum UIRow: Int {
        case alertController
        case modalTransitioning
        case count
    }

    private enum ExtensionsRow: Int {
        case keyboardScroller
        case dateHelper
        case urlValidation
        case count
    }

    private let ExampleTableViewControllerCellIdentifier = "ExampleTableViewControllerCellIdentifier"
        
    // MARK: - UITableViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo-appmazo"))
    }
    
    // MARK: - PermissionsTableViewController
    
    private func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
        switch (indexPath.section, indexPath.row) {
        case (Section.managers.rawValue, ManagersRow.permissions.rawValue):
            return "Permissions Manager"
        case (Section.managers.rawValue, ManagersRow.location.rawValue):
            return "Location Manager"
        case (Section.managers.rawValue, ManagersRow.biometrics.rawValue):
            return "Biometrics Manager"
        case (Section.managers.rawValue, ManagersRow.ratings.rawValue):
            return "Ratings Manager"
        case (Section.ui.rawValue, UIRow.alertController.rawValue):
            return "Alert Controllers"
        case (Section.ui.rawValue, UIRow.modalTransitioning.rawValue):
            return "Modal Transitioning"
        case (Section.extensions.rawValue, ExtensionsRow.keyboardScroller.rawValue):
            return "Keyboard Scroller"
        case (Section.extensions.rawValue, ExtensionsRow.dateHelper.rawValue):
            return "Date Helper"
        case (Section.extensions.rawValue, ExtensionsRow.urlValidation.rawValue):
            return "URL Validation"
        default:
            return nil
        }
    }
    
    private func subtitleForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
        switch (indexPath.section, indexPath.row) {
        case (Section.managers.rawValue, ManagersRow.permissions.rawValue):
            return "Helps streamline and manage common OS level permissions such as Location, Push Notifications and more."
        case (Section.managers.rawValue, ManagersRow.location.rawValue):
            return "Helps manage the user's location by providing a simplified manager with useful functions like getting user's current location, allowing custom locations entered as an address, storing last used location and more."
        case (Section.managers.rawValue, ManagersRow.biometrics.rawValue):
            return "A simple way for storing user credentials for use with Biometric verification."
        case (Section.managers.rawValue, ManagersRow.ratings.rawValue):
            return "A simple way for tracking and prompting users to rate your app."
        case (Section.ui.rawValue, UIRow.alertController.rawValue):
            return "A simple, efficient and familiar alert controller for a more elegant way to alert users."
        case (Section.ui.rawValue, UIRow.modalTransitioning.rawValue):
            return "UIViewControllerContextTransitioning for presenting modals."
        case (Section.extensions.rawValue, ExtensionsRow.keyboardScroller.rawValue):
            return "A simple keyboard observer to allow UIScrollView to automatically scroll fields into view when the keyboard appears."
        case (Section.extensions.rawValue, ExtensionsRow.dateHelper.rawValue):
            return "A simple way to compare dates."
        case (Section.extensions.rawValue, ExtensionsRow.urlValidation.rawValue):
            return "A simple way to check if a URL can load a valid website."
        default:
            return nil
        }
    }
}

extension ExampleTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.managers.rawValue:
            return ManagersRow.count.rawValue
        case Section.ui.rawValue:
            return UIRow.count.rawValue
        case Section.extensions.rawValue:
            return ExtensionsRow.count.rawValue
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Section.managers.rawValue:
            return "Managers"
        case Section.ui.rawValue:
            return "UI"
        case Section.extensions.rawValue:
            return "Extensions"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExampleTableViewControllerCellIdentifier, for: indexPath)
        cell.textLabel?.text = titleForRowAtIndexPath(indexPath)
        cell.detailTextLabel?.text = subtitleForRowAtIndexPath(indexPath)
        cell.detailTextLabel?.numberOfLines = 0
        
        return cell
    }
}

extension ExampleTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (Section.managers.rawValue, ManagersRow.permissions.rawValue):
            navigationController?.pushViewController(PermissionsManagerTableViewController.viewControllerFromStoryboard(), animated: true)
        case (Section.managers.rawValue, ManagersRow.location.rawValue):
            navigationController?.pushViewController(LocationManagerTableViewController.viewControllerFromStoryboard(), animated: true)
        case (Section.managers.rawValue, ManagersRow.ratings.rawValue):
            navigationController?.pushViewController(RatingsManagerTableViewController.viewControllerFromStoryboard(), animated: true)
        case (Section.managers.rawValue, ManagersRow.biometrics.rawValue):
            navigationController?.pushViewController(BiometricsViewController.viewControllerFromStoryboard(), animated: true)
        case (Section.ui.rawValue, UIRow.alertController.rawValue):
            navigationController?.pushViewController(AlertControllerTableViewController.viewControllerFromStoryboard(), animated: true)
        case (Section.ui.rawValue, UIRow.modalTransitioning.rawValue):
            navigationController?.pushViewController(ModalTransitioningTableViewController.viewControllerFromStoryboard(), animated: true)
        case (Section.extensions.rawValue, ExtensionsRow.keyboardScroller.rawValue):
            navigationController?.pushViewController(KeyboardScrollerViewController.viewControllerFromStoryboard(), animated: true)
        case (Section.extensions.rawValue, ExtensionsRow.dateHelper.rawValue):
            navigationController?.pushViewController(DateHelperTableViewController.viewControllerFromStoryboard(), animated: true)
        case (Section.extensions.rawValue, ExtensionsRow.urlValidation.rawValue):
            navigationController?.pushViewController(URLValidationViewController.viewControllerFromStoryboard(), animated: true)
        default:
            break
        }
    }
}
