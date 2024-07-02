//
//  AddToDoReactor.swift
//  ToDoGeo
//
//  Created by SUN on 4/21/24.
//

import ReactorKit
import RxFlow
import RxCocoa

final class AddToDoReactor: Reactor, Stepper {
    var steps: PublishRelay<Step>
    
    var initialState: State
    
    init(initialState: State) {
        self.initialState = initialState
        self.steps = PublishRelay<Step>()
    }
    
    struct State {
        /// todo
        var toDo: ToDo = .init()
        /// 위치 이름 입력창 에러
        var locationTextFieldError: ToDoTextFieldError = .none
        /// ToDo 입력값 입력창 에러
        var titleTextFieldError: ToDoTextFieldError = .none
        /// 추가 버튼 활성화 flag
        var isEnableAddButton: Bool = false
        
    }
    
    enum Action {
        /// 추가 버튼 클릭
        case didTapAddButton
        /// todo 위치 이름 입력
        case inputLocationName(String)
        /// todo 이름 입력
        case inputToDoTitle(String)
        /// todo 위치 추가
        case inputToDoLocation
    }
    
    enum Mutation {
        /// todo 추가
        case addToDo
        /// 추가 버튼 유효성 체크
        case checkValicationForAddButton
        /// 위치 이름 유효성 체크
        case checkValidationForLocationName
        /// todo 이름 유효성 체크
        case checkValidationForToDoTitle
        /// todo 위치 이름 맵핑
        case setLocationName(String)
        /// todo 이름 맵핑
        case setToDoTitle(String)
        /// todo 위치 맵핑
        case setToDoLocation
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapAddButton:
            return .empty()
            
        case .inputLocationName(let input):
            return Observable.concat([.just(Mutation.setLocationName(input)),
                                      .just(Mutation.checkValidationForLocationName),
                                      .just(.checkValicationForAddButton)])
            
        case .inputToDoTitle(let input):
            return Observable.concat([.just(Mutation.setToDoTitle(input)),
                                      .just(Mutation.checkValidationForToDoTitle),
                                      .just(.checkValicationForAddButton)])
            
        case .inputToDoLocation:
            return Observable.just(Mutation.setToDoLocation)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .addToDo:
            break
            
        case .checkValicationForAddButton:
            newState.isEnableAddButton = newState.titleTextFieldError == .none &&
            newState.locationTextFieldError == .none &&
            !newState.toDo.title.isEmpty &&
            !newState.toDo.locationName.isEmpty
            
        case .checkValidationForLocationName:
            if newState.toDo.locationName.isEmpty {
                newState.locationTextFieldError = .emptyTextField
            } else if newState.toDo.locationName.count > 15 {
                newState.locationTextFieldError = .overLength
            } else {
                newState.locationTextFieldError = .none
            }
            
        case .checkValidationForToDoTitle:
            if newState.toDo.title.isEmpty {
                newState.titleTextFieldError = .emptyTextField
            } else if newState.toDo.title.count > 15 {
                newState.titleTextFieldError = .overLength
            } else {
                newState.titleTextFieldError = .none
            }
            
        case .setLocationName(let input):
            newState.toDo.locationName = input
            
        case .setToDoTitle(let input):
            newState.toDo.title = input
            
        case .setToDoLocation:
            // TODO: 위치 입력
            break
        }
        
        return newState
    }
}
