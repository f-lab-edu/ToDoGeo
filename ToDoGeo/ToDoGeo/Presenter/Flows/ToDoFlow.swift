//
//  ToDoFlow.swift
//  ToDoGeo
//
//  Created by SUN on 4/21/24.
//

import UIKit

import RxFlow

final class ToDoFlow: Flow {
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
        case .toDoRequired:
            return navigateToToDoMaps()
            
        default:
            return .none
        }
    }
    
    
}

//MARK: 화면 이동 로직
private
extension ToDoFlow {
    func navigateToToDo() -> FlowContributors {
        let viewController = AddToDoViewController()
        let reactor = AddToDoReactor(addToDoUseCase: AddToDoUseCase(toDoRepository: ToDoRepository()),
                                    initialState: .init())
        viewController.bind(reactor: reactor)
        self.rootViewController.setViewControllers([viewController], animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    func navigateToToDoMaps() -> FlowContributors {
        let viewController = ToDoMapsViewController()
        let reactor = ToDoMapsReactor(getToDoUseCase: GetToDoUseCase(toDoRepository: ToDoRepository()),
                                      initialState: .init())
        viewController.bind(reactor: reactor)
        self.rootViewController.setViewControllers([viewController], animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
}
