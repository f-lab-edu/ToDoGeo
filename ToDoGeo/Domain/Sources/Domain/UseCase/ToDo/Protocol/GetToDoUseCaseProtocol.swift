//
//  GetToDoUseCaseProtocol.swift
//  ToDoGeo
//
//  Created by SUN on 7/9/24.
//

import RxSwift

public protocol GetToDoUseCaseProtocol {
    /// todo 목록 불러오기
    /// - Returns: todo 목록
    func getList() -> Observable<[ToDo]>
}
