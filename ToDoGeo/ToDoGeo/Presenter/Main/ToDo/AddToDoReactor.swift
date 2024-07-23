//
//  AddToDoReactor.swift
//  ToDoGeo
//
//  Created by SUN on 4/21/24.
//

import CoreLocation

import ReactorKit
import RxFlow
import RxCocoa
import Shared

final class AddToDoReactor: Reactor, Stepper {
    private let addToDoUseCase: AddToDoUseCaseProtocol
    var disposeBag = DisposeBag()
    
    var steps: PublishRelay<Step>
    var initialState: State
    private let maxTextFieldLength: Int = 15
    
    init(addToDoUseCase: AddToDoUseCaseProtocol,
         initialState: State) {
        self.initialState = initialState
        self.addToDoUseCase = addToDoUseCase
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
        /// 나가기 버튼 클릭
        case didTapDismissButton
        /// todo 위치 이름 입력
        case inputLocationName(String)
        /// todo 이름 입력
        case inputToDoTitle(String)
        /// todo 위치 추가
        case inputToDoLocation(CLLocationCoordinate2D)
        /// todo 위치 맵핑
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
        case setToDoLocation(CLLocationCoordinate2D)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapAddButton:
            addToDo()
            return .empty()
            
        case .didTapDismissButton:
            steps.accept(AppStep.dismissAddToDoRequired)
            return .empty()
            
        case .inputLocationName(let input):
            return Observable.concat([.just(Mutation.setLocationName(input)),
                                      .just(Mutation.checkValidationForLocationName),
                                      .just(.checkValicationForAddButton)])
            
        case .inputToDoTitle(let input):
            return Observable.concat([.just(Mutation.setToDoTitle(input)),
                                      .just(Mutation.checkValidationForToDoTitle),
                                      .just(.checkValicationForAddButton)])
            
        case .inputToDoLocation(let location):
            return Observable.just(Mutation.setToDoLocation(location))
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
            } else if newState.toDo.locationName.count > maxTextFieldLength {
                newState.locationTextFieldError = .overLength
            } else {
                newState.locationTextFieldError = .none
            }
            
        case .checkValidationForToDoTitle:
            if newState.toDo.title.isEmpty {
                newState.titleTextFieldError = .emptyTextField
            } else if newState.toDo.title.count > maxTextFieldLength {
                newState.titleTextFieldError = .overLength
            } else {
                newState.titleTextFieldError = .none
            }
            
        case .setLocationName(let input):
            newState.toDo.locationName = input
            
        case .setToDoTitle(let input):
            newState.toDo.title = input
            
        case .setToDoLocation(let location):
            newState.toDo.location = location
        }
        
        return newState
    }
    
    private func addToDo() {
        addToDoUseCase.add(currentState.toDo)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] in
                self?.steps.accept(AppStep.dismissAddToDoRequired)
            } onError: { error in
                AlertManager.shared.showInfoAlert(message: error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
}
