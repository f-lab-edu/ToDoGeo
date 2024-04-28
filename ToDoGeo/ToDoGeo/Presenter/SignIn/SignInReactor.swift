//
//  SignInReactor.swift
//  ToDoGeo
//
//  Created by SUN on 4/21/24.
//

import ReactorKit
import RxFlow
import RxCocoa

final class SignInReactor: Reactor, Stepper {
    var steps: PublishRelay<Step>
    
    var initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
        self.steps = PublishRelay<Step>()
    }
    
    struct State {
        //TODO: 프로퍼티 추가 예정
    }
    
    enum Action {
        //TODO: 프로퍼티 추가 예정
    }
}
