//
//  ToDoRepository.swift
//  ToDoGeo
//
//  Created by SUN on 7/2/24.
//

import FirebaseAuth
import FirebaseDatabaseInternal
import RxSwift

final class ToDoRepository: ToDoRepositoryProtocol {
    /// ToDo 등록
    /// - Parameter todo: 등록할 ToDo
    /// - Returns: 등록 결과
    func addToDo(_ todo: ToDo) -> Observable<Void> {
        Observable.create { observer -> Disposable in
            guard let userId = Auth.auth().currentUser?.uid  else {
                observer.onError(FireBaseAuthError.invalidUserId)
                return Disposables.create()
            }
            
            let ref = Database.database().reference().child("users").child(userId).child("todos").childByAutoId()
            ref.setValue(todo.toDictionary()){
                (error:Error?, ref:DatabaseReference) in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(())
                }
            }
            
            return Disposables.create()
        }
    }
}
