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
    private let ref = Database.database(url: "https://todogeo-69749-default-rtdb.asia-southeast1.firebasedatabase.app/").reference()
}

extension ToDoRepository: ToDoRepositoryProtocol {
    /// ToDo 등록
    /// - Parameter todo: 등록할 ToDo
    /// - Returns: 등록 결과
    func addToDo(_ todo: ToDo) -> Observable<Void> {
        Observable.create { [weak self] observer -> Disposable in
            guard let userId = Auth.auth().currentUser?.uid  else {
                observer.onError(FireBaseAuthError.invalidUserId)
                return Disposables.create()
            }
            
            let autoId = self?.ref.key
            self?.ref.child("users").child(userId).child("todos").childByAutoId().setValue(todo.toDictionary()) { (error: Error?, ref: DatabaseReference) in
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
    func getToDos() -> Observable<ToDos> {
        Observable.create { [weak self] observer -> Disposable in
            guard let userId = Auth.auth().currentUser?.uid  else {
                observer.onError(FireBaseAuthError.invalidUserId)
                return Disposables.create()
            }
            
            self?.ref.child("users").child(userId).child("todos").observeSingleEvent(of: .value) { snapshot in
                    
                var todos: ToDos = .init()
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let dict = childSnapshot.value as? [String: Any] {
                        //                       let todo = ToDo.fromDictionary(dict) {
                        if let title = dict["title"] as? String,
                           let locationDict = dict["location"] as? [String: Any],
                           let latitude = locationDict["latitude"] as? CLLocationDegrees,
                           let longitude = locationDict["longitude"] as? CLLocationDegrees,
                           let locationName = dict["locationName"] as? String {
                            
                            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            todos.todos[childSnapshot.key] = ToDo(title: title, location: location, locationName: locationName)
                        }
                    }
                }
                
                observer.onNext(todos)
            }
            return Disposables.create()
        }
    }
}
