//
//  AppStepper.swift
//  ToDoGeo
//
//  Created by SUN on 4/21/24.
//

import FirebaseAuth
import RxFlow
import RxSwift
import RxCocoa
import Shared

final public class AppStepper: Stepper {
    public init() {}
    
    public let steps = PublishRelay<Step>()
    let disposeBag = DisposeBag()
    
    public var initialStep: Step {
        if let userId = Auth.auth().currentUser?.uid,
           userId == Utility.load(key: Constant.userID) {
            return AppStep.toDoRequired
        } else {
            return AppStep.signInRequired
        }
    }
}
