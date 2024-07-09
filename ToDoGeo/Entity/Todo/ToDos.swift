//
//  ToDos.swift
//  ToDoGeo
//
//  Created by SUN on 7/9/24.
//

import Foundation

struct ToDos {
    var todos: [String: ToDo]
    
    init(todos: [String : ToDo] = [:]) {
        self.todos = todos
    }
}
