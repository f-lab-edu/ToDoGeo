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
        return UINavigationController()
    }()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else {
            return .none
        }
        
        switch step {
        case .signInRequired:
            return self.navigateToSignIn()
            
        case .toDoRequired:
            return .end(forwardToParentFlowWithStep: AppStep.toDoRequired)
            
        default:
            return .none
        }
    }
}

//MARK: 화면 이동 로직
private
extension SignInFlow {
    func navigateToSignIn() -> FlowContributors {
        let viewController = SignInViewController()
        let reactor = SignInReactor(signInUseCase: SignInUseCase(signInRepository: SignInRepository()),
                                    initialState: .init())
        viewController.bind(reactor: reactor)
        self.rootViewController.setViewControllers([viewController], animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
}
