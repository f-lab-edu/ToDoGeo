//
//  CompleteToDoUseCase.swift
//  ToDoGeo
//
//  Created by SUN on 7/21/24.
//

import RxSwift

final public class CompleteToDoUseCase {
    private let toDoRepository: ToDoRepositoryProtocol
    
    public init(toDoRepository: ToDoRepositoryProtocol) {
        self.toDoRepository = toDoRepository
    }
}

extension CompleteToDoUseCase: CompleteToDoUseCaseProtocol {
    public func completeToDo(_ item: ToDo) -> Observable<Void> {
        return toDoRepository.remove(item)
    }
}
