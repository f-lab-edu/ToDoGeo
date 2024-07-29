//
//  CompleteToDoUseCase.swift
//  ToDoGeo
//
//  Created by SUN on 7/21/24.
//

import RxSwift

final class CompleteToDoUseCase {
    private let toDoRepository: ToDoRepositoryProtocol
    
    init(toDoRepository: ToDoRepositoryProtocol) {
        self.toDoRepository = toDoRepository
    }
}

extension CompleteToDoUseCase: CompleteToDoUseCaseProtocol {
    func completeToDo(_ item: ToDo) -> Observable<Void> {
        return toDoRepository.remove(item)
    }
}
