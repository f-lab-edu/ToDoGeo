//
//  GetToDoUseCaseProtocol.swift
//  ToDoGeo
//
//  Created by SUN on 7/9/24.
//

import RxSwift

protocol GetToDoUseCaseProtocol {
    /// todo 목록 불러오기
    /// - Returns: todo 목록
    func getToDos() -> Observable<[ToDo]>
}
