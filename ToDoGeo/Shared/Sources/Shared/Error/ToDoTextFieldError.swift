//
//  ToDoTextFieldError.swift
//  ToDoGeo
//
//  Created by SUN on 6/30/24.
//

import Foundation

public enum ToDoTextFieldError {
    /// 에러 없음
    case none
    /// 입력값 공백
    case emptyTextField
    /// 입력값 제한 초과
    case overLength
    
    public var errorMessage: String {
        switch self {
        case .none:
            return ""
            
        case .emptyTextField:
            return "1글자 이상 입력해 주세요."
            
        case .overLength:
            return "15자 이상 입력 할 수 없습니다."
        }
    }
}
