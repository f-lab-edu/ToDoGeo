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
        var emailInput: String = ""
        /// email 입력값에 대한 오류 메시지
        var errorMessageForEmailInput: String = ""
        /// email 입력값에 대한 오류 메시지
        var errorMessageForPasswordInput: String = ""
        /// password input
        var passwordInput: String = ""
        /// email 유효성 체크 관련 플래그
        var isValidEmail: Bool = false
        /// password 유효성 체크 관련 플래그
        var isValidPassword: Bool = false
        
        var isEnableSignInButton: Bool = false
    }
    
    enum Action {
        /// email 입력창 완료 버튼 클릭
        case didTappedDoneButtonInEmailTextField
        /// 비밀번호 입력창 완료 버튼 클릭
        case didTappedDoneButtonInPasswordTextField
        /// 로그인 버튼 클릭
        case didTappedSignInButton
        /// email 입력
        case inputEmail(email: String)
        /// 비밀번호 입력
        case inputPassword(password: String)
    }
    
    enum Mutation {
        /// email 유효성체크 기능 추가
        case checkValidationForEmail
        /// password 유효성체크 기능 추가
        case checkValidationForPassword
        /// email input mapping
        case setEmailInput(email: String)
        /// password input mapping
        case setPasswordInput(password: String)
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTappedSignInButton:
            requestSignIn(email: currentState.emailInput, password: currentState.passwordInput)
            
            return .empty()
        case .didTappedDoneButtonInEmailTextField:
            return Observable.just(Mutation.checkValidationForEmail)
            
        case .didTappedDoneButtonInPasswordTextField:
            return Observable.just(Mutation.checkValidationForPassword)
            
        case .inputEmail(let email):
            return Observable.just(Mutation.setEmailInput(email: email))
            
        case .inputPassword(let password):
            return Observable.just(Mutation.setPasswordInput(password: password))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .checkValidationForEmail:
            newState.isValidEmail = checkValidationForEmail(email: newState.emailInput)
            
            if newState.isValidEmail == false {
                newState.errorMessageForEmailInput = "올바른 이메일 형식이 아닙니다."
                newState.isEnableSignInButton = false
            } else {
                newState.errorMessageForEmailInput = ""
                if newState.isValidPassword == true {
                    newState.isEnableSignInButton = true
                }
            }
            
        case .checkValidationForPassword:
            newState.isValidPassword = checkValidationForPassword(password: newState.passwordInput)
            
            if newState.isValidPassword == false {
                newState.errorMessageForPasswordInput = "올바른 비밀번호 형식이 아닙니다."
                newState.isEnableSignInButton = false
            } else {
                newState.errorMessageForPasswordInput = ""
                if newState.isValidEmail == true {
                    newState.isEnableSignInButton = true
                }
            }
            
        case .setEmailInput(let email):
            newState.emailInput = email
            
        case .setPasswordInput(let password):
            newState.passwordInput = password
        }
        
        return newState
    }
}

extension SignInReactor {
    /// email 유효성 체크 함수
    func checkValidationForEmail(email: String) -> Bool {
        guard email.isEmpty == false else {
            return false
        }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
       
        return Utility.checkRegEx(input: email, regEx: emailRegEx)
    }
    
    func checkValidationForPassword(password: String) -> Bool {
        guard password.isEmpty == false else {
            return false
        }
        
        let passwordRegEx = "(?=.*[A-Za-z])(?=.*[0-9]).{8,20}"
        
        return Utility.checkRegEx(input: password, regEx: passwordRegEx)
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
