//
//  Date+Extensions.swift
//  AppmazoKit
//
//  Created by James Hickman on 5/19/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import Foundation

public extension Date {
    /**
     Calculate the difference in between two dates.
     
     - parameter date: The date to compare against.
     - returns: Number of years between the two dates.
     */
    func years(fromDate date: Date) -> Int? {
        return Calendar.current.dateComponents([.year], from: date, to: self).year
    }
    
    /**
     Calculate the difference in between two dates.
     
     - parameter date: The date to compare against.
     - returns: Number of months between the two dates.
     */
    func months(fromDate date: Date) -> Int? {
        return Calendar.current.dateComponents([.month], from: date, to: self).month
    }
    
    /**
     Calculate the difference in between two dates.
     
     - parameter date: The date to compare against.
     - returns: Number of weeks between the two dates.
     */
    func weeks(fromDate date: Date) -> Int? {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear
    }
    
    /**
     Calculate the difference in between two dates.
     
     - parameter date: The date to compare against.
     - returns: Number of days between the two dates.
     */
    func days(fromDate date: Date) -> Int? {
        return Calendar.current.dateComponents([.day], from: date, to: self).day
    }
    
    /**
     Calculate the difference in between two dates.
     
     - parameter date: The date to compare against.
     - returns: Number of hours between the two dates.
     */
    func hours(fromDate date: Date) -> Int? {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour
    }
    
    /**
     Calculate the difference in between two dates.
     
     - parameter date: The date to compare against.
     - returns: Number of minutes between the two dates.
     */
    func minutes(fromDate date: Date) -> Int? {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute
    }
    
    /**
     Calculate the difference in between two dates.
     
     - parameter date: The date to compare against.
     - returns: Number of seconds between the two dates.
     */
    func seconds(fromDate date: Date) -> Int? {
        return Calendar.current.dateComponents([.second], from: date, to: self).second
    }
}
