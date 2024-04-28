//
//  AppFlow.swift
//  ToDoGeo
//
//  Created by SUN on 4/21/24.
//

import UIKit

import RxFlow

final class AppFlow: Flow {
    var root: Presentable {
        return rootWindow
    }
    
    private let rootWindow: UIWindow

    init(withWindow window: UIWindow) {
        self.rootWindow = window
    }
    
    func navigate(to step: Step) -> RxFlow.FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .signInRequired:
            return self.navigateToSignin()
        case .toDoRequired:
            return self.navigateToToDo()
        default:
            return .none
        }
    }
    
    
}

//MARK: 화면 이동 로직
private
extension AppFlow {
    func navigateToSignin() -> FlowContributors {
        let singInFlow = SignInFlow()
        Flows.use(singInFlow, when: .created) { [weak self] (root) in
            self?.rootWindow.rootViewController = root
        }
        return .one(flowContributor: .contribute(withNextPresentable: singInFlow, withNextStepper: OneStepper(withSingleStep: AppStep.signInRequired)))
    }
    
    func navigateToToDo() -> FlowContributors {
        let todoFlow = ToDoFlow()
        Flows.use(todoFlow, when: .created) { [weak self] (root) in
            self?.rootWindow.rootViewController = root
        }
        return .one(flowContributor: .contribute(withNextPresentable: todoFlow, withNextStepper: OneStepper(withSingleStep: AppStep.toDoRequired)))
    }
}
