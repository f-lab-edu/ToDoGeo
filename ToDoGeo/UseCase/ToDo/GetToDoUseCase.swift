//
//  GetToDoUseCase.swift
//  ToDoGeo
//
//  Created by SUN on 7/9/24.
//

import RxSwift

final class GetToDoUseCase {
    private let toDoRepository: ToDoRepositoryProtocol
    
    init(toDoRepository: ToDoRepositoryProtocol) {
        self.toDoRepository = toDoRepository
    }
}

extension GetToDoUseCase: GetToDoUseCaseProtocol {
    /// todo 목록 불러오기
    /// - Returns: todo 목록
    func getToDos() -> Observable<ToDos> {
        toDoRepository.getToDos()
            .asObservable()
    }
}
