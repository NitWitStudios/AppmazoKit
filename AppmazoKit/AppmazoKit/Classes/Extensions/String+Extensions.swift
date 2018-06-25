//
//  String+Extensions.swift
//  AppmazoKit
//
//  Created by James Hickman on 6/25/18.
//

import Foundation

public extension String {
    /**
     Create a camel cased string.
     
     - returns: A camel cased version of the string.
     */
    public func camelCased() -> String {
        var camelCasedString = ""
        let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        for (index, string) in components.enumerated() {
            let formattedString = index == 0 ? string.lowercased() : string.lowercased().capitalized
            camelCasedString += formattedString
        }
        
        return camelCasedString
    }
}
