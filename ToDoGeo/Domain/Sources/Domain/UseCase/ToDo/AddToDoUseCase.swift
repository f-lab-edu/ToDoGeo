//
//  AddToDoUseCase.swift
//  ToDoGeo
//
//  Created by SUN on 7/2/24.
//

import RxSwift

final public class AddToDoUseCase {
    private let toDoRepository: ToDoRepositoryProtocol
    
    public init(toDoRepository: ToDoRepositoryProtocol) {
        self.toDoRepository = toDoRepository
    }
}

extension AddToDoUseCase: AddToDoUseCaseProtocol {
    /// ToDo 등록
    /// - Parameter todo: 등록할 ToDo
    /// - Returns: 등록 결과
    public func add(_ item: ToDo) -> Observable<Void> {
        toDoRepository.add(item)
            .asObservable()
    }
}
