//
//  ToDoAnnotation.swift
//  ToDoGeo
//
//  Created by SUN on 7/21/24.
//

import Foundation
import MapKit

final class ToDoAnnotation: NSObject, MKAnnotation {
    var todo: ToDo
    var coordinate: CLLocationCoordinate2D
    
    var title: String? {
        return todo.title
    }
    
    var subtitle: String? {
        return todo.locationName
    }
    
    init(todo: ToDo,
         coordinate: CLLocationCoordinate2D) {
        self.todo = todo
        self.coordinate = coordinate
    }
}
