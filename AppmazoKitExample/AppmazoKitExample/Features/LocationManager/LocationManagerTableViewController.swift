//
//  LocationManagerTableViewController.swift
//  AppmazoKitExample
//
//  Created by James Hickman on 5/13/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import AppmazoKit
import UIKit

class LocationManagerTableViewController: UITableViewController, Storyboardable {    
    private let UITableViewCellReuseIdentifier = "UITableViewCellReuseIdentifier"
    
    private enum LocationManagerTableViewControllerSection: Int {
        case location
        case count
    }
    
    private enum LocationManagerTableViewControllerLocationRow: Int {
        case currentLocation
        case locationAddress
        case count
    }
    
    private let permissionsManager = PermissionsManager()
    
    // MARK: - Init
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - UITableViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Location Manager"        
        LocationManager.shared.initialize()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCellReuseIdentifier)
        tableView.register(PermissionPromptTableViewCell.self, forCellReuseIdentifier: PermissionPromptTableViewCell.reuseIdentifier)
        tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.reuseIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(permissionManagerDidUpdateLocation(_:)), name: LocationManager.didUpdateLocationNotificationName, object: nil)
    }
    
    // MARK: - LocationManagerTableViewController
    
    private func locationCellForIndexPath(_ indexPath: IndexPath) -> UITableViewCell {
        if permissionsManager.isLocationsAuthorized() {
            switch indexPath.row {
            case LocationManagerTableViewControllerLocationRow.currentLocation.rawValue:
                let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCellReuseIdentifier, for: indexPath)
                cell.textLabel?.text = "Use Current Location"
                let locationSwitch = UISwitch()
                locationSwitch.isOn = !LocationManager.shared.useCustomLocation
                locationSwitch.addTarget(self, action: #selector(locationSwitchUpdated(_:)), for: .valueChanged)
                cell.accessoryView = locationSwitch
                return cell
            case LocationManagerTableViewControllerLocationRow.locationAddress.rawValue:
                if let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.reuseIdentifier, for: indexPath) as? LocationTableViewCell {
                    cell.delegate = self
                    
                    if LocationManager.shared.isLocationUpdating {
                        cell.locationText = "Updating your location..."
                        cell.state = .loading
                    } else if LocationManager.shared.currentLocation == nil {
                        cell.locationText = LocationManager.shared.currentAddress
                        cell.state = .customLocation
                    } else if LocationManager.shared.currentLocation != nil {
                        cell.locationText = LocationManager.shared.currentAddress
                        if LocationManager.shared.useCustomLocation || !permissionsManager.isLocationsAuthorized() {
                            cell.state = .customLocation
                        } else {
                            cell.state = .userLocation
                        }
                    }
                    
                    return cell
                }
            default:
                break
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: PermissionPromptTableViewCell.reuseIdentifier, for: indexPath) as? PermissionPromptTableViewCell {
                cell.delegate = self
                cell.permissionType = .locationAlways
                cell.enabled = !permissionsManager.isLocationsAuthorized()
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    @objc private func locationSwitchUpdated(_ sender: UISwitch) {
        LocationManager.shared.useCustomLocation = !sender.isOn
        tableView.reloadData()
    }
    
    @objc private func permissionManagerDidUpdateLocation(_ sender: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return LocationManagerTableViewControllerSection.count.rawValue
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case LocationManagerTableViewControllerSection.location.rawValue:
            return permissionsManager.isLocationsAuthorized() ? 2 : 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        switch indexPath.section {
        case LocationManagerTableViewControllerSection.location.rawValue:
            cell = locationCellForIndexPath(indexPath)
        default:
            cell = UITableViewCell()
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
}

extension LocationManagerTableViewController: PermissionPromptTableViewCellDelegate {
    func permissionPromptTableViewCell(_ permissionPromptTableViewCell: PermissionPromptTableViewCell, buttonPressed: Button) {
        permissionsManager.requestLocationPermission(.authorizedAlways)
    }
}

extension LocationManagerTableViewController: LocationTableViewCellDelegate {
    func locationTableViewCell(_ locationTableViewCell: LocationTableViewCell, locationTextUpdated locationText: String?) {
        LocationManager.shared.updateLocationWithAddress(locationText) { (correctedAddress, location, error) in
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    func locationTableViewCell(_ locationTableViewCell: LocationTableViewCell, locationButtonPressed locationButton: Button) {
        locationTableViewCell.state = .loading
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0, execute: { // Add delay for smooth loading UI.
            LocationManager.shared.startUpdatingLocation()
        })
    }
}
