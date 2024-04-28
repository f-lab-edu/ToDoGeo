//
//  AppStepper.swift
//  ToDoGeo
//
//  Created by SUN on 4/21/24.
//

import Foundation

import RxFlow
import RxSwift
import RxCocoa

final class AppStepper: Stepper {
    
    let steps = PublishRelay<Step>()
    let disposeBag = DisposeBag()
    
    var initialStep: Step {
        return AppStep.toDoRequired
    }
}
