//
//  ToDoResponseDto.swift
//  ToDoGeo
//
//  Created by SUN on 7/12/24.
//

import Foundation

struct ToDosResponseDto: Codable {
    var todos: [String: ToDoResponseDto]?
}

struct ToDoResponseDto: Codable {
    var id: String?
    var locationName: String?
    var title: String?
    var location: LocationDto?
}

struct LocationDto: Codable {
    var latitude: Double?
    var longitude: Double?
}

extension ToDosResponseDto {
    func toDomain() -> [ToDo] {
        return todos?.values.map({
            ToDo(id: .init(uuidString: $0.id ?? "") ?? UUID(),
                 title: $0.title ?? "",
                 location: .init(latitude: $0.location?.latitude ?? 0.0,
                                 longitude: $0.location?.longitude ?? 0.0),
                 locationName: $0.locationName ?? "") }) ?? []
    }
}
