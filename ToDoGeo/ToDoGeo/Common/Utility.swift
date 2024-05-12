//
//  Utility.swift
//  ToDoGeo
//
//  Created by SUN on 5/5/24.
//

import Foundation

final class Utility {
    static func checkRegEx(input: String, regEx: String) -> Bool {
        return NSPredicate(format:"SELF MATCHES %@", regEx).evaluate(with: input)
    }
}
