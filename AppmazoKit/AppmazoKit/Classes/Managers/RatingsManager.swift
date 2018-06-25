//
//  RatingsManager.swift
//  AppmazoKit
//
//  Created by James Hickman on 6/12/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import Foundation
import StoreKit

public class RatingsManager: NSObject {
    private enum UserDefaultsKey: String {
        case ratedVersion = "RatingsManager.ratedVersion"
        case currentEventCount = "RatingsManager.currentEventCount"
        case requiredEventCount = "RatingsManager.requiredEventCount"
        case datePrompted = "RatingsManager.datePrompted"
        case dateShouldPrompt = "RatingsManager.dateShouldPrompt"
        case daysToPrompt = "RatingsManager.daysToPrompt"
    }

    public static var isVersionRated: Bool {
        get {
            return UserDefaults.standard.string(forKey: UserDefaultsKey.ratedVersion.rawValue) == Bundle.appVersion()
        }
        set {
            UserDefaults.standard.set(newValue ? Bundle.appVersion(): nil, forKey: UserDefaultsKey.ratedVersion.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    public static var currentEventCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKey.currentEventCount.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.currentEventCount.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    public static var requiredEventCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKey.requiredEventCount.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.requiredEventCount.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    public static var datePrompted: Date? {
        get {
            return UserDefaults.standard.object(forKey: UserDefaultsKey.datePrompted.rawValue) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.datePrompted.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    public static var daysToPrompt: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKey.daysToPrompt.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.daysToPrompt.rawValue)
            UserDefaults.standard.synchronize()

            if newValue > 0 {
                RatingsManager.dateShouldPrompt = Date(timeIntervalSinceNow: TimeInterval(60*60*24*newValue))
            } else {
                RatingsManager.dateShouldPrompt = nil
            }
        }
    }

    public static var dateShouldPrompt: Date? {
        get {
            return UserDefaults.standard.object(forKey: UserDefaultsKey.dateShouldPrompt.rawValue) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKey.dateShouldPrompt.rawValue)
            UserDefaults.standard.synchronize()
        }
    }

    public class func shouldPromptForRating() -> Bool {
        let isEventCountMet = RatingsManager.currentEventCount >= RatingsManager.requiredEventCount
        var isPastRemindPeriod = true
        
        if let dateShouldPrompt = RatingsManager.dateShouldPrompt, RatingsManager.datePrompted != nil {
            isPastRemindPeriod = Date() >= dateShouldPrompt
        }
        
        if !RatingsManager.isVersionRated && isEventCountMet && isPastRemindPeriod {
            return true
        }
        
        return false
    }
    
    public class func promptForRating() {
        SKStoreReviewController.requestReview()
        RatingsManager.datePrompted = Date()
        RatingsManager.isVersionRated = true
    }
    
    public class func reset() {
        RatingsManager.currentEventCount = 0
        RatingsManager.datePrompted = nil
        RatingsManager.dateShouldPrompt = nil
        RatingsManager.isVersionRated = false
    }
}
