//
//  PermissionsManager.swift
//  AppmazoKit
//
//  Created by James Hickman on 5/12/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit
import CoreLocation

public class LocationManager: NSObject {
    public static let shared : LocationManager = {
        let instance = LocationManager()
        return instance
    }()
        
    public static let didUpdateLocationNotificationName = NSNotification.Name(rawValue: "PermissionsManagerDidUpdateLocationName")
    public static let didUpdateLocationPermissionNotificationName = NSNotification.Name(rawValue: "PermissionsManagerDidUpdateLocationPermissionName")

    private let PermissionsManagerShouldUseCustomLocationKey = "PermissionsManagerShouldUseCustomLocationKey"
    private let PermissionsManagerLastLocationLatitudeKey = "PermissionsManagerLastLocationLatitudeKey"
    private let PermissionsManagerLastLocationLongitudeKey = "PermissionsManagerLastLocationLongitudeKey"

    private let permissionsManager = PermissionsManager()
    private var locationManager = CLLocationManager()
    
    public var isLocationUpdating = false
    public var currentLocation: CLLocation?
    public var currentAddress: String?
    
    public var useCustomLocation: Bool = false {
        didSet {
            UserDefaults.standard.set(useCustomLocation, forKey: PermissionsManagerShouldUseCustomLocationKey)
            UserDefaults.standard.synchronize()
            startUpdatingLocation()
        }
    }
    
    public var distanceFilter: Double = 1609.34 * 1.0 // Meters x Miles
    public var desiredAccuracy = kCLLocationAccuracyHundredMeters
    
    // MARK: - Init
    
    public func initialize() {
        locationManager.delegate = self
        locationManager.distanceFilter = distanceFilter
        locationManager.desiredAccuracy = desiredAccuracy
        useCustomLocation = UserDefaults.standard.bool(forKey: PermissionsManagerShouldUseCustomLocationKey)
        startUpdatingLocation()
    }
    
    // MARK: - Private
    
    private func postUpdatedLocationNotification() {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: LocationManager.didUpdateLocationNotificationName, object: nil, userInfo: nil)
        }
    }
    
    private func lastLocation() -> CLLocation? {
        if let latitude = UserDefaults.standard.value(forKey: PermissionsManagerLastLocationLatitudeKey) as? Double, let longitude = UserDefaults.standard.value(forKey: PermissionsManagerLastLocationLongitudeKey) as? Double {
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        
        return nil
    }
    
    private func updateToLocation(_ location: CLLocation?, address: String? = nil) {
        currentLocation = location

        guard let location = location else {
            isLocationUpdating = false
            currentAddress = nil
            UserDefaults.standard.removeObject(forKey: PermissionsManagerLastLocationLatitudeKey)
            UserDefaults.standard.removeObject(forKey: PermissionsManagerLastLocationLongitudeKey)

            postUpdatedLocationNotification()
            return
        }
        
        UserDefaults.standard.set(location.coordinate.latitude, forKey: PermissionsManagerLastLocationLatitudeKey)
        UserDefaults.standard.set(location.coordinate.longitude, forKey: PermissionsManagerLastLocationLongitudeKey)
        UserDefaults.standard.synchronize()

        addressForLocation(location, completion: {[weak self] (address, error) in
            self?.currentAddress = address
            self?.isLocationUpdating = false
            
            self?.postUpdatedLocationNotification()
        })
    }
    
    private func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    private func addressStringForPlacemark(_ placemark: CLPlacemark) -> String? {
        var address = ""
        if let city = placemark.locality, let state = placemark.administrativeArea, let postalCode = placemark.postalCode {
            address = city + ", " + state + ", " + postalCode
        } else if let city = placemark.locality, let state = placemark.administrativeArea {
            address = city + ", " + state
        } else if let city = placemark.administrativeArea {
            address = city
        } else if let postalCode = placemark.postalCode {
            address = postalCode
        }
        
        return address
    }
    
    private func addressForLocation(_ location: CLLocation, completion: @escaping (_ addressString: String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {[weak self] (placemarks, error) -> Void in
            if let error = error {
                completion(nil, error)
            } else if let placemark = placemarks?.first {
                completion(self?.addressStringForPlacemark(placemark), nil)
            }
        })
    }

    private func clearLocation() {
        updateToLocation(nil, address: nil)
        postUpdatedLocationNotification()
    }
    
    // MARK: - Public
    
    public func startUpdatingLocation(_ completion: ((Error?) -> Void)? = nil) {
        if useCustomLocation || !permissionsManager.isLocationsAuthorized() {
            isLocationUpdating = true
            if let lastLocation = lastLocation() {
                updateToLocation(lastLocation)
                
                addressForLocation(lastLocation, completion: {[weak self] (addressString, error) in
                    if let error = error {
                        completion?(error)
                    } else {
                        self?.currentAddress = addressString
                    }
                    self?.isLocationUpdating = false
                    
                    self?.postUpdatedLocationNotification()
                })
            } else {
                isLocationUpdating = false
            }
        } else if permissionsManager.isLocationsAuthorized() {
            isLocationUpdating = true
            locationManager.stopUpdatingLocation()
            locationManager.startUpdatingLocation()
        }
    }
    
    public func updateLocationWithAddress(_ address: String?, completion: @escaping (_ correctedAddressString: String?, _ location: CLLocation?, _ error: Error?) -> ()) {
        guard let address = address, address.count > 0 else {
            updateToLocation(nil)
            return
        }
        
        CLGeocoder().geocodeAddressString(address) {[weak self] (placemarks, error) in
            if let error = error {
                completion(nil, nil, error)
            } else if let placemark = placemarks?.first, let location = placemark.location {
                let addressString = self?.addressStringForPlacemark(placemark)
                self?.currentAddress = addressString
                self?.updateToLocation(location)
                completion(addressString, location, nil)
                
                self?.postUpdatedLocationNotification()
            } else {
                completion(nil, nil, error)
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    // MARK: - CLLocationManagerDelegate
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            startUpdatingLocation()
        } else if status == .denied {
            stopUpdatingLocation()
        }
        NotificationCenter.default.post(name: LocationManager.didUpdateLocationPermissionNotificationName, object: nil, userInfo: nil)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateToLocation(locations.first)
    }
}
