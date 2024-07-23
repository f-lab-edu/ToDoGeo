//
//  ToDosResponseDto.swift
//
//
//  Created by SUN on 7/23/24.
//

import Foundation
import Domain

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
    var lat: Double?
    var lng: Double?
}

extension ToDosResponseDto {
    func toDomain() -> [ToDo] {
        return todos?.values.map({
            ToDo(id: .init(uuidString: $0.id ?? "") ?? UUID(),
                 title: $0.title ?? "",
                 location: .init(latitude: $0.location?.lat ?? 0.0,
                                 longitude: $0.location?.lng ?? 0.0),
                 locationName: $0.locationName ?? "") }) ?? []
    }
}
