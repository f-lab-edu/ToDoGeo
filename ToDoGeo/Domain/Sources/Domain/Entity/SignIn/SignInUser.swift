//
//  SignInUser.swift
//  ToDoGeo
//
//  Created by SUN on 6/12/24.
//

import Foundation

public struct SignInUser {
    /// 사용자 uuid
    public var id: String
    /// 사용자 email
    public var email: String
    /// 사용자 이름
    public var name: String
    
    public init(id: String, 
                email: String,
                name: String) {
        self.id = id
        self.email = email
        self.name = name
    }
}
