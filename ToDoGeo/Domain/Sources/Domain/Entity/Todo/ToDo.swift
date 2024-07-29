//
//  ToDo.swift
//  ToDoGeo
//
//  Created by SUN on 6/15/24.
//

import CoreLocation

public struct ToDo {
    public var id: UUID
    /// 제목
    public var title: String
    /// 알림 받을 위치
    public  var location: CLLocationCoordinate2D
    /// 위치 이름
    public var locationName: String
    
    public init(id: UUID = UUID(),
         title: String = "",
         location: CLLocationCoordinate2D = .init(),
         locationName: String = "") {
        self.id = id
        self.title = title
        self.location = location
        self.locationName = locationName
    }
}

extension ToDo {
    public func toDic() -> [String: Any] {
        return [
            "id": id.uuidString,
            "title": title,
            "location": ["lat": location.latitude, "lng": location.longitude],
            "locationName": locationName
        ]
    }
}
