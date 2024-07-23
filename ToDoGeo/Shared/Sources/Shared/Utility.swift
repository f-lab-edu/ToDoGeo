//
//  Utility.swift
//  ToDoGeo
//
//  Created by SUN on 5/5/24.
//

import Foundation

public struct Utility {
    public static func checkRegEx(input: String, regEx: String) -> Bool {
        return NSPredicate(format:"SELF MATCHES %@", regEx).evaluate(with: input)
    }
    
    public static func save(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    public static func load(key: String) -> String {
        if let value = UserDefaults.standard.string(forKey: key) {
            return value
        } else {
            return ""
        }
    }
    
    public static func delete(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
