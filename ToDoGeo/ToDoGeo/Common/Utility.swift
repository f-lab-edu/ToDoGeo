//
//  Utility.swift
//  ToDoGeo
//
//  Created by SUN on 5/5/24.
//

import Foundation

struct Utility {
    static func checkRegEx(input: String, regEx: String) -> Bool {
        return NSPredicate(format:"SELF MATCHES %@", regEx).evaluate(with: input)
    }
    
    static func save(key: String, value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func load(key: String) -> String {
        if let value = UserDefaults.standard.string(forKey: key) {
            return value
        } else {
            return ""
        }
    }
    
    static func delete(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
