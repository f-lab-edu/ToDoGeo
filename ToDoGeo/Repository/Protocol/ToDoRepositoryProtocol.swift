//
//  ToDoRepositoryProtocol.swift
//  ToDoGeo
//
//  Created by SUN on 7/2/24.
//

import RxSwift

protocol ToDoRepositoryProtocol {
    /// ToDo 등록
    /// - Parameter todo: 등록할 ToDo
    /// - Returns: 등록 결과
    func addToDo(_ todo: ToDo) -> Observable<Void>
    
    /// todo 목록 불러오기
    /// - Returns: todo 목록
    func getToDos() -> Observable<ToDos>
}