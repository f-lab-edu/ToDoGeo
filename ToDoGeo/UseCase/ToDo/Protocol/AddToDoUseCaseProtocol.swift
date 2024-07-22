//
//  AddToDoUseCaseProtocol.swift
//  ToDoGeo
//
//  Created by SUN on 7/2/24.
//

import RxSwift

protocol AddToDoUseCaseProtocol {
    /// ToDo 등록
    /// - Parameter todo: 등록할 ToDo
    /// - Returns: 등록 결과
    func add(_ item: ToDo) -> Observable<Void>
}
