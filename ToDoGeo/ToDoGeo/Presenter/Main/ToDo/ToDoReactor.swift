//
//  ToDoReactor.swift
//  ToDoGeo
//
//  Created by SUN on 4/21/24.
//

import ReactorKit
import RxFlow
import RxCocoa

final class ToDoReactor: Reactor, Stepper {
    var steps: PublishRelay<Step>
    
    var initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
        self.steps = PublishRelay<Step>()
    }
    
    struct State {
        
    }
    
    enum Action {
    
    }
}
