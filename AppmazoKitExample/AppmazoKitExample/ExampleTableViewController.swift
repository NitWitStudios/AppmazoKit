//
//  ExampleTableViewController.swift
//  AppmazoKit
//
//  Created by James Hickman on 5/12/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit

class ExampleTableViewController: UITableViewController {
    private enum Section: Int {
        case main
        case count
    }
    
    private enum Row: Int {
        case permissionsManager
        case locationManager
        case count
    }

    private let ExampleTableViewControllerCellIdentifier = "ExampleTableViewControllerCellIdentifier"
    
    // MARK: - Init
    
    // MARK: - UITableViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo-appmazo"))
    }
    
    // MARK: - PermissionsTableViewController
    
    func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
        switch (indexPath.section, indexPath.row) {
        case (Section.main.rawValue, Row.permissionsManager.rawValue):
            return "Permissions Manager"
        case (Section.main.rawValue, Row.locationManager.rawValue):
            return "Location Manager"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ExampleTableViewControllerCellIdentifier, for: indexPath)
        
        cell.textLabel?.text = titleForRowAtIndexPath(indexPath)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (Section.main.rawValue, Row.permissionsManager.rawValue):
            performSegue(withIdentifier: PermissionsManagerTableViewController.segueIdentifier, sender: self)
        case (Section.main.rawValue, Row.locationManager.rawValue):
            performSegue(withIdentifier: LocationManagerTableViewController.segueIdentifier, sender: self)
        default:
            break
        }
    }
}
