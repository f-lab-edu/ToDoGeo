//
//  AppStep.swift
//  ToDoGeo
//
//  Created by SUN on 4/21/24.
//

import RxFlow

/// 화면 이동 로직
enum AppStep: Step {
    /// sign In 화면으로 이동
    case signInRequired
    /// sign up 화면으로 이동
    case signUpRequired
    
    /// todo 화면으로 이동
    case toDoRequired
}
