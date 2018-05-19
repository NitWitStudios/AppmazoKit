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
        case main
        case count
    }
    
    private enum Row: Int {
        case permissionsManager
        case locationManager
        case alertController
        case splashAnimationViewController
        case keyboardScroller
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
        case (Section.main.rawValue, Row.permissionsManager.rawValue):
            return "Permissions Manager"
        case (Section.main.rawValue, Row.locationManager.rawValue):
            return "Location Manager"
        case (Section.main.rawValue, Row.alertController.rawValue):
            return "Alert Controllers"
        case (Section.main.rawValue, Row.splashAnimationViewController.rawValue):
            return "Splash Animation"
        case (Section.main.rawValue, Row.keyboardScroller.rawValue):
            return "Keyboard Scroller"
        default:
            return nil
        }
    }
    
    private func subtitleForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
        switch (indexPath.section, indexPath.row) {
        case (Section.main.rawValue, Row.permissionsManager.rawValue):
            return "Helps streamline and manage common OS level permissions such as Location, Push Notifications and more."
        case (Section.main.rawValue, Row.locationManager.rawValue):
            return "Helps manage the user's location by providing a simplified manager with useful functions like getting user's current location, allowing custom locations entered as an address, storing last used location and more."
        case (Section.main.rawValue, Row.alertController.rawValue):
            return "A simple, efficient and familiar alert controller for a more elegant way to alert users."
        case (Section.main.rawValue, Row.splashAnimationViewController.rawValue):
            return "A simple view controller for showing a splash screen animation."
        case (Section.main.rawValue, Row.keyboardScroller.rawValue):
            return "A simple keyboard observer to allow UIScrollView to automatically scroll fields into view when the keyboard appears."
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
        cell.detailTextLabel?.text = subtitleForRowAtIndexPath(indexPath)
        cell.detailTextLabel?.numberOfLines = 0
        
        return cell
    }
    
    // MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (Section.main.rawValue, Row.permissionsManager.rawValue):
            navigationController?.pushViewController(PermissionsManagerTableViewController.viewControllerFromStoryboard(), animated: true)
        case (Section.main.rawValue, Row.locationManager.rawValue):
            navigationController?.pushViewController(LocationManagerTableViewController.viewControllerFromStoryboard(), animated: true)
        case (Section.main.rawValue, Row.alertController.rawValue):
            navigationController?.pushViewController(AlertControllerTableViewController.viewControllerFromStoryboard(), animated: true)
        case (Section.main.rawValue, Row.splashAnimationViewController.rawValue):
            if let filepath = Bundle.main.path(forResource: "Appmazo Logo Animation", ofType: "mp4") {
                let fileURL = URL(fileURLWithPath: filepath)
                let splashVideoViewController = SplashVideoViewController(videoURL: fileURL, videoSize: CGSize(width: 250.0, height: 150.0))
                present(splashVideoViewController, animated: true) {
                    splashVideoViewController.playVideo(completion: {
                        splashVideoViewController.dismiss(animated: true, completion: nil)
                    })
                }
            }
        case (Section.main.rawValue, Row.keyboardScroller.rawValue):
            navigationController?.pushViewController(KeyboardScrollerViewController.viewControllerFromStoryboard(), animated: true)
        default:
            break
        }
    }
}
