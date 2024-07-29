//
//  CompleteToDoUseCaseProtocol.swift
//  ToDoGeo
//
//  Created by SUN on 7/21/24.
//

import RxSwift

public protocol CompleteToDoUseCaseProtocol {
    
    /// todo 완료
    /// - Parameter item: 완료할 todo
    /// - Returns: 결과
    func completeToDo(_ item: ToDo) -> Observable<Void>
}
