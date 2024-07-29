//
//  AppleSignInError.swift
//  ToDoGeo
//
//  Created by SUN on 6/13/24.
//

import Foundation

public enum AppleSignInError: Error {
    case invalidCredential(message: String)
    case existedAccount
}
