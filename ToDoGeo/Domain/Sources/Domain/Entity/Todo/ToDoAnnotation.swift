//
//  ToDoAnnotation.swift
//  
//
//  Created by SUN on 7/23/24.
//

import MapKit

final public class ToDoAnnotation: NSObject, MKAnnotation {
    public var todo: ToDo
    public var coordinate: CLLocationCoordinate2D
    
    public var title: String? {
        return todo.title
    }
    
    public var subtitle: String? {
        return todo.locationName
    }
    
    public init(todo: ToDo,
                coordinate: CLLocationCoordinate2D) {
        self.todo = todo
        self.coordinate = coordinate
    }
}
