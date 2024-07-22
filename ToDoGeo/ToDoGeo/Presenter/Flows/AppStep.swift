//
//  AppStep.swift
//  ToDoGeo
//
//  Created by SUN on 4/21/24.
//

import RxFlow

/// 화면 이동 로직
enum AppStep: Step {
    //MARK: 회원가입/로그인 관련 이동 case
    /// sign In 화면으로 이동
    case signInRequired
    /// sign up 화면으로 이동
    case signUpRequired
    
    //MARK: todo 화면 이동 로직 case
    /// todo 추가 화면으로 이동
    case addToDoRequired
    /// todo 추가 화면 dismiss
    case dismissAddToDoRequired
    /// todo 화면으로 이동
    case toDoRequired
    
}
