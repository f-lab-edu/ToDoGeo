//
//  ToDoRepository.swift
//  ToDoGeo
//
//  Created by SUN on 7/2/24.
//

import FirebaseAuth
import FirebaseDatabaseInternal
import RxSwift
import CoreLocation

final class ToDoRepository {
    private let ref = Database.database().reference()
}

extension ToDoRepository: ToDoRepositoryProtocol {
    /// ToDo 등록
    /// - Parameter todo: 등록할 ToDo
    /// - Returns: 등록 결과
    func add(_ todo: ToDo) -> Observable<Void> {
        Observable.create { [weak self] observer -> Disposable in
            guard let userId = Auth.auth().currentUser?.uid  else {
                observer.onError(FireBaseAuthError.invalidUserId)
                return Disposables.create()
            }
            
            let autoId = self?.ref.key
            self?.ref.child("users").child(userId).child("todos").child("\(todo.id)").setValue(todo.toDic()) { (error: Error?, ref: DatabaseReference) in
                if let error = error {
                    observer.onError(error)
                } else {
                    if let id = autoId {
                        LocationManger.shared.registerLocationForGeofence(id: id, location: todo.location)
                    }
                    observer.onNext(())
                }
            }
            
            return Disposables.create()
        }
    }
    
    /// todo 목록 불러오기
    /// - Returns: todo 목록
    func getList() -> Observable<[ToDo]> {
        Observable.create { [weak self] observer -> Disposable in
            guard let userId = Auth.auth().currentUser?.uid  else {
                observer.onError(FireBaseAuthError.invalidUserId)
                return Disposables.create()
            }
            
            self?.ref.child("users").child(userId).child("todos").observe(.value) { snapshot  in
                do {
                    let data = try JSONSerialization.data(withJSONObject: [snapshot.key: snapshot.value])
                    let todos = try JSONDecoder().decode(ToDosResponseDto.self, from: data)
                    observer.onNext(todos.toDomain())
                } catch let error {
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
