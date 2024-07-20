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

final class AppStepper: Stepper {
    
    let steps = PublishRelay<Step>()
    let disposeBag = DisposeBag()
    
    var initialStep: Step {
//        if let userId = Auth.auth().currentUser?.uid,
//           userId == Utility.load(key: Constant.userID) {
            return AppStep.toDoRequired
//        } else {
//            return AppStep.signInRequired
//        }
    }
}
