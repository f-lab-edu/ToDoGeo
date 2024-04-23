//
//  ToDoFlow.swift
//  ToDoGeo
//
//  Created by SUN on 4/21/24.
//

import RxFlow
import UIKit

final class ToDoFlow: Flow {
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
        case .toDoRequired:
            return self.navigateToToDo()
        default:
            return .none
        }
    }
    
    
}

// MARK: 화면 이동 로직
private
extension ToDoFlow {
    func navigateToToDo() -> FlowContributors {
        let viewController = ToDoViewController()
        let reactor = ToDoReactor(initialState: .init())
        self.rootViewController.setViewControllers([viewController], animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
}
