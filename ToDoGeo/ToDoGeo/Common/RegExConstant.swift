//
//  RegExConstant.swift
//  ToDoGeo
//
//  Created by SUN on 5/9/24.
//

import Foundation

enum RegExConstant {
    /// 이메일 유효성 체크 정규식
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    /// 비밀번호 유효성 체크 정규식
    static let password = "(?=.*[A-Za-z])(?=.*[0-9]).{8,20}"

}
