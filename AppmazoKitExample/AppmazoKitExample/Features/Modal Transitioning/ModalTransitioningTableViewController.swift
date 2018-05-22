//
//  ModalTransitioningTableViewController.swift
//  AppmazoKitExample
//
//  Created by James Hickman on 5/19/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit
import AppmazoKit

class ModalTransitioningTableViewController: UITableViewController, Storyboardable {
    private enum Section: Int {
        case main
        case count
    }
    
    private enum Row: Int {
        case clearBackground
        case transparentBackground
        case blurredBackground
        case count
    }
    
    // MARK: - UITableViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Modal Transitioning"
    }

    // MARK: - ModalTransitioningTableViewController
    
    private func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
        switch (indexPath.section, indexPath.row) {
        case (Section.main.rawValue, Row.clearBackground.rawValue):
            return "Modal with Clear Background"
        case (Section.main.rawValue, Row.transparentBackground.rawValue):
            return "Modal with Transparent Background"
        case (Section.main.rawValue, Row.blurredBackground.rawValue):
            return "Modal with Blurred Background"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = titleForRowAtIndexPath(indexPath)
        
        return cell
    }

    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var modalBackgroundStyle: ModalTransitioning.BackgroundStyle
        switch (indexPath.section, indexPath.row) {
        case (Section.main.rawValue, Row.clearBackground.rawValue):
            modalBackgroundStyle = .clear
        case (Section.main.rawValue, Row.transparentBackground.rawValue):
            modalBackgroundStyle = .transparent
        case (Section.main.rawValue, Row.blurredBackground.rawValue):
            modalBackgroundStyle = .blurred
        default:
            modalBackgroundStyle = .clear
        }
        
        let alertController = AlertController.alertControllerWithTitle("Modal Transition", message: "This is an example of how Modal Transitioning works. Pretty neat huh?")
        alertController.modalBackgroundStyle = modalBackgroundStyle
        alertController.addAction(AlertAction(withTitle: "Dismiss", style: .filled, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
