//
//  ToDoFlow.swift
//  ToDoGeo
//
//  Created by SUN on 4/21/24.
//

import UIKit
import Domain
import Data
import RxFlow

final public class ToDoFlow: Flow {
    public var root: Presentable {
        return rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        return UINavigationController()
    }()
    
    public func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else {
            return .none
        }
        
        switch step {
        case .toDoRequired:
            return navigateToToDoMaps()
            
        case .addToDoRequired:
            return presentToAddToDo()
            
        case .dismissAddToDoRequired:
            return dismissAddToDo()
            
        default:
            return .none
        }
    }
    
    
}

//MARK: 화면 이동 로직
private extension ToDoFlow {
    func dismissAddToDo() -> FlowContributors {
        rootViewController.dismiss(animated: true)
        return .none
    }
    
    func presentToAddToDo() -> FlowContributors {
        let viewController = AddToDoViewController()
        let reactor = AddToDoReactor(addToDoUseCase: AddToDoUseCase(toDoRepository: ToDoRepository()),
                                    initialState: .init())
        viewController.bind(reactor: reactor)
        rootViewController.present(viewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
    
    func navigateToToDoMaps() -> FlowContributors {
        let viewController = ToDoMapsViewController()
        let reactor = ToDoMapsReactor(completeToDoUseCase: CompleteToDoUseCase(toDoRepository: ToDoRepository()),
                                      getToDoUseCase: GetToDoUseCase(toDoRepository: ToDoRepository()),
                                      initialState: .init())
        viewController.bind(reactor: reactor)
        self.rootViewController.setViewControllers([viewController], animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: viewController, withNextStepper: reactor))
    }
}
