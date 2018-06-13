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
    private struct KeychainConfiguration {
        static let serviceName = "RatingsManagerServiceName"
        static let account = "RatingsManagerAccount"
        static let accessGroup: String? = nil
    }
    
    private enum UserDefaultsKey: String {
        case isVersionRated = "RatingsManager.isVersionRated"
        case eventCount = "RatingsManager.eventCount"
        case eventsUntilPrompt = "RatingsManager.eventsUntilPrompt"
        case lastReminded = "RatingsManager.lastReminded"
        case remindPeriod = "RatingsManager.remindPeriod"
    }

    public var isVersionRated: Bool {
        get {
            return UserDefaults.standard.bool(forKey: UserDefaultsKey.isVersionRated.rawValue)
        }
        set {
            UserDefaults.standard.set(isVersionRated, forKey: UserDefaultsKey.isVersionRated.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var eventCount: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKey.eventCount.rawValue)
        }
        set {
            UserDefaults.standard.set(eventCount, forKey: UserDefaultsKey.eventCount.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var eventsUntilPrompt: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKey.eventsUntilPrompt.rawValue)
        }
        set {
            UserDefaults.standard.set(eventsUntilPrompt, forKey: UserDefaultsKey.eventsUntilPrompt.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var lastReminded: Date? {
        get {
            return UserDefaults.standard.object(forKey: UserDefaultsKey.lastReminded.rawValue) as? Date
        }
        set {
            UserDefaults.standard.set(lastReminded, forKey: UserDefaultsKey.lastReminded.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var remindPeriod: Int {
        get {
            return UserDefaults.standard.integer(forKey: UserDefaultsKey.remindPeriod.rawValue)
        }
        set {
            UserDefaults.standard.set(remindPeriod, forKey: UserDefaultsKey.remindPeriod.rawValue)
            UserDefaults.standard.synchronize()
        }
    }

    public func shouldPromptForRating() -> Bool {
        let isEventCountMet = RatingsManager.eventCount >= RatingsManager.eventsUntilPrompt
        var isPastRemindPeriod = true
        
        if let lastReminded = RatingsManager.lastReminded, let daysSinceLastReminder = lastReminded.days(fromDate: Date()) {
            isPastRemindPeriod = daysSinceLastReminder > RatingsManager.remindPeriod
        }
        
        if !isVersionRated && isEventCountMet && isPastRemindPeriod {
            return true
        } else {
            RatingsManager.eventCount = RatingsManager.eventCount + 1
        }
        
        return false
    }
    
    public func promptForRating() {
        SKStoreReviewController.requestReview()
        RatingsManager.lastReminded = Date()
    }
}
