//
//  SignInReactorTests.swift
//  ToDoGeoTests
//
//  Created by SUN on 5/4/24.
//

import XCTest
@testable import ToDoGeo

final class SignInReactorTests: XCTestCase {
    var reactor: SignInReactor!
    
    override func setUpWithError() throws {
        reactor = SignInReactor(initialState: .init())
    }
    
    override func tearDown() {
        reactor = nil
    }
    
    // MARK: - email 유효성 관련 테스트
    func testEmailInput_WhenEmailInputIsEmpty_EmailInputIsInvalid() {
        
        reactor.action.onNext(.inputEmail(input: ""))
        
        reactor.action.onNext(.didTappedDoneButtonInEmailTextField)
        
        XCTAssertEqual(reactor.currentState.emailInput, "")
        XCTAssertEqual(reactor.currentState.isValidEmail, false)
        XCTAssertEqual(reactor.currentState.errorMessageForEmailInput, "올바른 이메일 형식이 아닙니다.")
    }
    
    func testEmailInput_WhenEmailInputIsNotEmailFormat_EmailInputIsInvalid() {
        
        reactor.action.onNext(.inputEmail(input: "ggg"))
        
        reactor.action.onNext(.didTappedDoneButtonInEmailTextField)
        
        XCTAssertEqual(reactor.currentState.emailInput, "ggg")
        XCTAssertEqual(reactor.currentState.isValidEmail, false)
        XCTAssertEqual(reactor.currentState.errorMessageForEmailInput, "올바른 이메일 형식이 아닙니다.")
    }
    
    func testEmailInput_WhenEmailInputIsEmailFormat_EmailInputIsValid() {
        
        reactor.action.onNext(.inputEmail(input: "wgt563@gmail.com"))
        
        reactor.action.onNext(.didTappedDoneButtonInEmailTextField)
        
        XCTAssertEqual(reactor.currentState.emailInput, "wgt563@gmail.com")
        XCTAssertEqual(reactor.currentState.isValidEmail, true)
        XCTAssertEqual(reactor.currentState.errorMessageForEmailInput, "")
    }
    
    // MARK: - 비밀번호 유효성 체크 테스트
    func testPasswordInput_WhenPasswordInputIsEmpty_PasswordInputIsInvalid() {
        
        reactor.action.onNext(.inputPassword(input: ""))
        
        reactor.action.onNext(.didTappedDoneButtonInPasswordTextField)
        
        XCTAssertEqual(reactor.currentState.pwInput, "")
        XCTAssertEqual(reactor.currentState.isValidPassword, false)
        XCTAssertEqual(reactor.currentState.errorMessageForPWInput, "올바른 비밀번호 형식이 아닙니다.")
    }
    
    func testPasswordInput_WhenPasswordInputIsOnlyLetters_PasswordInputIsInvalid() {
        reactor.action.onNext(.inputPassword(input: "ggggggggg"))
        
        reactor.action.onNext(.didTappedDoneButtonInPasswordTextField)
        
        XCTAssertEqual(reactor.currentState.pwInput, "ggggggggg")
        XCTAssertEqual(reactor.currentState.isValidPassword, false)
        XCTAssertEqual(reactor.currentState.errorMessageForPWInput, "올바른 비밀번호 형식이 아닙니다.")
    }
    
    func testPasswordInput_WhenPasswordInputIsOnlyNumbers_PasswordInputIsInvalid() {
        reactor.action.onNext(.inputPassword(input: "123433524857"))
        
        reactor.action.onNext(.didTappedDoneButtonInPasswordTextField)
        
        XCTAssertEqual(reactor.currentState.pwInput, "123433524857")
        XCTAssertEqual(reactor.currentState.isValidPassword, false)
        XCTAssertEqual(reactor.currentState.errorMessageForPWInput, "올바른 비밀번호 형식이 아닙니다.")
    }
    
    func testPasswordInput_WhenPasswordInputIsPasswordFormat_PasswordInputIsValid() {
        reactor.action.onNext(.inputPassword(input: "gggg123456"))
        
        reactor.action.onNext(.didTappedDoneButtonInPasswordTextField)
        
        XCTAssertEqual(reactor.currentState.pwInput, "gggg123456")
        XCTAssertEqual(reactor.currentState.isValidPassword, true)
        XCTAssertEqual(reactor.currentState.errorMessageForPWInput, "")
    }
}
