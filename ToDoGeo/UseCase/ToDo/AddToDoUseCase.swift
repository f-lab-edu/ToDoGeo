//
//  AddToDoUseCase.swift
//  ToDoGeo
//
//  Created by SUN on 7/2/24.
//

import RxSwift

final class AddToDoUseCase {
    private let toDoRepository: ToDoRepositoryProtocol
    
    init(toDoRepository: ToDoRepositoryProtocol) {
        self.toDoRepository = toDoRepository
    }
}

extension AddToDoUseCase: AddToDoUseCaseProtocol {
    /// ToDo 등록
    /// - Parameter todo: 등록할 ToDo
    /// - Returns: 등록 결과
    func addToDo(_ todo: ToDo) -> Observable<Void> {
        toDoRepository.addToDo(todo)
            .asObservable()
    }
}
