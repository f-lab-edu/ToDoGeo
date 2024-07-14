//
//  ToDoMapsReactor.swift
//  ToDoGeo
//
//  Created by SUN on 7/13/24.
//

import ReactorKit
import RxFlow
import RxCocoa

final class ToDoMapsReactor: Reactor, Stepper {
    private let getToDoUseCase: GetToDoUseCaseProtocol
    var steps: PublishRelay<Step>
    var disposeBag = DisposeBag()

    var initialState: State
    
    init(getToDoUseCase: GetToDoUseCaseProtocol,
         initialState: State) {
        self.initialState = initialState
        self.getToDoUseCase = getToDoUseCase
        self.steps = PublishRelay<Step>()
    }
    
    struct State {
        var todos: [ToDo] = []
    }
    
    enum Action {
        case didTapFloatButton
        case viewDidLoad
    }
    
    enum Mutation {
        case setTodos([ToDo])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
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

private
extension ToDoMapsReactor {
    func getToDos() -> Observable<[ToDo]> {
        getToDoUseCase.getToDos()
            .observe(on: MainScheduler.instance)
            .map({
                return $0
            })
            .do(onError: { error in
                AlertManager.shared.showInfoAlert(message: error.localizedDescription)
            })
            .catchAndReturn([])
    }
}
