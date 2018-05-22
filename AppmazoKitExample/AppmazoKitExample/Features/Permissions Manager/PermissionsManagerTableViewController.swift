//
//  PermissionsManagerTableViewController.swift
//  AppmazoKit
//
//  Created by James Hickman on 5/12/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit
import AppmazoKit

class PermissionsManagerTableViewController: UITableViewController, Storyboardable, PermissionPromptTableViewCellDelegate {    
    private let permissionsManager = PermissionsManager()
    
    enum Section: Int {
        case location
        case notifications
        case biometrics
        case count
    }
    
    enum LocationRow: Int {
        case always
        case whenInUse
        case count
    }
    
    enum NotificationsRow: Int {
        case push
        case count
    }

    enum BiometricsRow: Int {
        case faceID
        case touchID
        case count
    }

    let biometricsManager = BiometricsManager()
    
    // MARK: - UITableViewController
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Permissions Manager"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        tableView.register(PermissionPromptTableViewCell.self, forCellReuseIdentifier: PermissionPromptTableViewCell.reuseIdentifier)
        
        permissionsManager.permissionsUpdatedBlock = { [weak self] (permissionType) in
            switch permissionType {
            case .location:
                self?.tableView.reloadSections([Section.location.rawValue], with: .automatic)
            case .notifications:
                self?.tableView.reloadSections([Section.notifications.rawValue], with: .automatic)
            default:
                break
            }
        }
    }

    // MARK: - PermissionsManagerTableViewController
    
    private func verifyUserWithBiometrics() {
        biometricsManager.verifyUserWithBiometrics { [weak self] (success, error) in
            DispatchQueue.main.async {
                if success {
                    self?.tableView.reloadData()
                } else if let _ = error {
                    let message = self?.biometricsManager.isFaceIDAvailable() == true ? "Looks like we had a problem verifying you with FaceID." : "Looks like we had a problem verifying you with TouchID."
                    let alertController = AlertController.alertControllerWithTitle("Uh-Oh", message: message)
                    alertController.image = self?.biometricsManager.isFaceIDAvailable() == true ? UIImage(named: "icon-face-id") : UIImage(named: "icon-touch-id")
                    alertController.addAction(AlertAction(withTitle: "Try Again", style: .filled, handler: { (alertAction) in
                        self?.verifyUserWithBiometrics()
                    }))
                    alertController.addAction(AlertAction(withTitle: "Dismiss", style: .normal, handler: nil))
                    self?.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case Section.location.rawValue:
            return "Location"
        case Section.notifications.rawValue:
            return "Notifications"
        case Section.biometrics.rawValue:
            return "Biometrics"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Section.location.rawValue:
            return LocationRow.count.rawValue
        case Section.notifications.rawValue:
            return NotificationsRow.count.rawValue
        case Section.biometrics.rawValue:
            return BiometricsRow.count.rawValue
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PermissionPromptTableViewCell.reuseIdentifier, for: indexPath) as? PermissionPromptTableViewCell {
            cell.delegate = self

            switch indexPath.section {
            case Section.location.rawValue:
                switch indexPath.row {
                case LocationRow.always.rawValue:
                    cell.permissionType = .locationAlways
                    cell.enabled = !permissionsManager.isLocationAuthorizedAlways()
                case LocationRow.whenInUse.rawValue:
                    cell.permissionType = .locationWhenInUse
                    cell.enabled = !permissionsManager.isLocationsAuthorized() // Should be enabled for both 'whenInUse' and 'always'
                default:
                    break
                }
            case Section.notifications.rawValue:
                switch indexPath.row {
                case NotificationsRow.push.rawValue:
                    cell.permissionType = .notifications
                    cell.enabled = !permissionsManager.isNotificationsAuthorized()
                default:
                    break
                }
            case Section.biometrics.rawValue:
                switch indexPath.row {
                case BiometricsRow.faceID.rawValue:
                    cell.permissionType = .faceID
                    cell.enabled = biometricsManager.isFaceIDAvailable()
                case BiometricsRow.touchID.rawValue:
                    cell.permissionType = .touchID
                    cell.enabled = biometricsManager.isTouchIDAvailable()
                default:
                    break
                }
            default:
                break
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    // MARK: - PermissionPromptTableViewCellDelegate
    
    func permissionPromptTableViewCell(_ permissionPromptTableViewCell: PermissionPromptTableViewCell, buttonPressed: Button) {
        let indexPath = tableView.indexPath(for: permissionPromptTableViewCell)
        
        switch indexPath?.section {
        case Section.location.rawValue:
            switch indexPath?.row {
            case LocationRow.always.rawValue:
                permissionsManager.requestLocationPermission(.authorizedAlways)
            case LocationRow.whenInUse.rawValue:
                permissionsManager.requestLocationPermission(.authorizedWhenInUse)
            default:
                break
            }
        case Section.notifications.rawValue:
            switch indexPath?.row {
            case NotificationsRow.push.rawValue:
                permissionsManager.requestNotificationsPermission()
            default:
                break
            }
        case Section.biometrics.rawValue:
            switch indexPath?.row {
            case BiometricsRow.faceID.rawValue, BiometricsRow.touchID.rawValue:
                verifyUserWithBiometrics()
            default:
                break
            }
        default:
            break
        }
    }
}
