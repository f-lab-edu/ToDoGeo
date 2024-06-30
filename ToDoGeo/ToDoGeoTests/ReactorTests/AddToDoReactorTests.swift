//
//  AddToDoReactorTests.swift
//  ToDoGeoTests
//
//  Created by SUN on 6/30/24.
//

import XCTest
@testable import ToDoGeo

final class AddToDoReactorTests: XCTestCase {
    var sut: AddToDoReactor!
    
    override func setUpWithError() throws {
        sut = AddToDoReactor(initialState: .init())
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    // location 이름이 작성되지 않을 경우 locationTextFieldError 가 EmptyTextField
    func testLocationNameInput_WhenLocationNameIsEmpty_LocationTextFieldErrorIsEmptyTextField() {
        sut.action.onNext(.inputLocationName(""))
        
        XCTAssertEqual(sut.currentState.toDo.locationName, "")
        XCTAssertEqual(sut.currentState.locationTextFieldError, .emptyTextField)
    }
    
    // location 이름이 15자 이상일 경우 locationTextFieldError 가 overLength
    func testLocationNameInput_WhenLocationNameLengthOver15_LocationTextFieldErrorIsOverLength() {
        sut.action.onNext(.inputLocationName("2134567890123456"))
        
        XCTAssertEqual(sut.currentState.toDo.locationName, "2134567890123456")
        XCTAssertEqual(sut.currentState.locationTextFieldError, .overLength)
    }
    
    // location 이름이 15자 이하일 경우 locationTextFieldError 가 none
    func testLocationNameInput_WhenLocationNameValid_LocationTextFieldErrorIsNone() {
        sut.action.onNext(.inputLocationName("적당한 이름"))
        
        XCTAssertEqual(sut.currentState.toDo.locationName, "적당한 이름")
        XCTAssertEqual(sut.currentState.locationTextFieldError, .none)
    }
    
    // ToDo 이름이 작성되지 않을 경우 titleTextFieldError 가 EmptyTextField
    func testToDoTitleInput_WhenToDoTitleIsEmpty_TitleTextFieldErrorIsEmptyTextField() {
        sut.action.onNext(.inputToDoTitle(""))
        
        XCTAssertEqual(sut.currentState.toDo.title, "")
        XCTAssertEqual(sut.currentState.titleTextFieldError, .emptyTextField)
    }
    
    // ToDo 이름이 15자 이상일 경우 locationTextFieldError 가 overLength
    func testLocationNameInput_WhenToDoTitleLengthOver15_TitleTextFieldErrorIsOverLength() {
        sut.action.onNext(.inputToDoTitle("2134567890123456"))
        
        XCTAssertEqual(sut.currentState.toDo.title, "2134567890123456")
        XCTAssertEqual(sut.currentState.titleTextFieldError, .overLength)
    }
    
    // ToDo 이름이 15자 이하일 경우 locationTextFieldError 가 none
    func testLocationNameInput_WhenToDoTitleValid_TitleTextFieldErrorIsNone() {
        sut.action.onNext(.inputToDoTitle("적당한 이름"))
        
        XCTAssertEqual(sut.currentState.toDo.title, "적당한 이름")
        XCTAssertEqual(sut.currentState.titleTextFieldError, .none)
    }
    

}
