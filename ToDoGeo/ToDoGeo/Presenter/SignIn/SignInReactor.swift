//
//  SignInReactor.swift
//  ToDoGeo
//
//  Created by SUN on 4/21/24.
//
import Foundation

import FirebaseAuth
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
        /// email input
        var emailInput = ""
        /// email 입력값에 대한 오류 메시지
        var errorMessageForEmailInput = ""
        /// email 입력값에 대한 오류 메시지
        var errorMessageForPWInput = ""
        /// password input
        var pwInput = ""
        /// email 유효성 체크 관련 플래그
        var isValidEmail = false
        /// password 유효성 체크 관련 플래그
        var isValidPassword = false
        
        var isEnableSignInButton = false
    }
    
    enum Action {
        /// email 입력창 완료 버튼 클릭
        case didTappedDoneButtonInEmailTextField
        /// 비밀번호 입력창 완료 버튼 클릭
        case didTappedDoneButtonInPasswordTextField
        /// 로그인 버튼 클릭
        case didTappedSignInButton
        /// email 입력
        case inputEmail(input: String)
        /// 비밀번호 입력
        case inputPassword(input: String)
    }
    
    enum Mutation {
        /// email 유효성체크 기능 추가
        case checkValidationForEmail
        /// password 유효성체크 기능 추가
        case checkValidationForPassword
        /// 로그인 버튼 활성화 체크
        case checkSignInButtonActive
        /// email input mapping
        case setEmailInput(input: String)
        /// password input mapping
        case setPasswordInput(input: String)
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTappedSignInButton:
            requestSignIn(email: currentState.emailInput, password: currentState.pwInput)
            return .empty()
            
        case .didTappedDoneButtonInEmailTextField:
            return Observable.just(Mutation.checkValidationForEmail)
            
        case .didTappedDoneButtonInPasswordTextField:
            return Observable.just(Mutation.checkValidationForPassword)
            
        case .inputEmail(let email):
            return Observable.concat(.just(Mutation.setEmailInput(input: email)),
                                     .just(Mutation.checkSignInButtonActive))
            
        case .inputPassword(let password):
            return Observable.concat(.just(Mutation.setPasswordInput(input: password)),
                                     .just(Mutation.checkSignInButtonActive))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .checkValidationForEmail:
            newState.isValidEmail = checkValidationForEmail(input: newState.emailInput)
            newState.errorMessageForEmailInput = newState.isValidEmail ? "" : "올바른 이메일 형식이 아닙니다."
            
        case .checkValidationForPassword:
            newState.isValidPassword = checkValidationForPassword(input: newState.pwInput)
            newState.errorMessageForPWInput = newState.isValidPassword ? "" : "올바른 비밀번호 형식이 아닙니다."
            
        case .checkSignInButtonActive:
            newState.isEnableSignInButton = checkValidationForPassword(input: newState.pwInput) && 
            checkValidationForEmail(input: newState.emailInput)
            
        case .setEmailInput(let email):
            newState.emailInput = email
            
        case .setPasswordInput(let password):
            newState.pwInput = password
        }
        
        return newState
    }
}

extension SignInReactor {
    /// email 유효성 체크 함수
    func checkValidationForEmail(input: String) -> Bool {
        guard !input.isEmpty else {
            return false
        }
       
        return Utility.checkRegEx(input: input, regEx: RegExConstant.email)
    }
    
    func checkValidationForPassword(input: String) -> Bool {
        guard !input.isEmpty else {
            return false
        }
        
        return Utility.checkRegEx(input: input, regEx: RegExConstant.password)
    }
}

// TODO: - Repository로 옮겨야함
extension SignInReactor {
    func requestSignIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if authResult != nil {
                print("로그인 성공")
                self?.steps.accept(AppStep.toDoRequired)
            } else {
                print("로그인 실패")
                print(error.debugDescription)
            }
        }
    }
}
