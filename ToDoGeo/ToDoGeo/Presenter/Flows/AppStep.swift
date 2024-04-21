//
//  AppStep.swift
//  ToDoGeo
//
//  Created by SUN on 4/21/24.
//

import RxFlow

enum AppStep: Step {
    case signInRequired
    case signUpRequired
    
    case toDoRequired
}
