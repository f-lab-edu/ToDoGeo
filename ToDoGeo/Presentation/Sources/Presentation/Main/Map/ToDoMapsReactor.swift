//
//  ToDoMapsReactor.swift
//  
//
//  Created by SUN on 7/23/24.
//

import ReactorKit
import Domain
import RxFlow
import RxCocoa
import Shared

final class ToDoMapsReactor: Reactor, Stepper {
    private let completeToDoUseCase: CompleteToDoUseCaseProtocol
    private let getToDoUseCase: GetToDoUseCaseProtocol
    var steps: PublishRelay<Step>
    var disposeBag = DisposeBag()

    var initialState: State
    
    init(completeToDoUseCase: CompleteToDoUseCaseProtocol,
         getToDoUseCase: GetToDoUseCaseProtocol,
         initialState: State) {
        self.initialState = initialState
        self.completeToDoUseCase = completeToDoUseCase
        self.getToDoUseCase = getToDoUseCase
        self.steps = PublishRelay<Step>()
    }
    
    struct State {
        var todos: [ToDo] = []
    }
    
    enum Action {
        case completeToDo(ToDo)
        case didTapFloatButton
        case viewDidLoad
    }
    
    enum Mutation {
        case setTodos([ToDo])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .completeToDo(let todo):
            completeToDo(todo)
            return .empty()
            
        case .didTapFloatButton:
            steps.accept(AppStep.addToDoRequired)
            return .empty()
            
        case .viewDidLoad:
            return getToDos().map({ Mutation.setTodos($0) })
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setTodos(let todos):
            newState.todos = todos
        }
        
        return newState
    }
}

private extension ToDoMapsReactor {
    func completeToDo(_ item: ToDo) {
        completeToDoUseCase.completeToDo(item)
            .observe(on: MainScheduler.instance)
            .subscribe(onError: { error in
                AlertManager.shared.showInfoAlert(message: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func getToDos() -> Observable<[ToDo]> {
        getToDoUseCase.getList()
            .observe(on: MainScheduler.instance)
            .map({ $0 })
            .do(onError: { error in
                AlertManager.shared.showInfoAlert(message: error.localizedDescription)
            })
            .catchAndReturn([])
    }
}
