//
//  SignInFlow.swift
//  ToDoGeo
//
//  Created by SUN on 4/21/24.
//

import UIKit
import RxFlow

final class SignInFlow: Flow {
    var root: Presentable {
        return rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .signInRequired:
            return self.navigateToSignIn()
        default:
            return .none
        }
    }
    
    
}

// MARK: 화면 이동 로직
private
extension SignInFlow {
    func navigateToSignIn() -> FlowContributors {
        let viewController = SignInViewController()
        let reactor = SignInReactor(initialState: .init())
        self.rootViewController.setViewControllers([viewController], animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
}
