//
//  ToDo.swift
//  ToDoGeo
//
//  Created by SUN on 6/15/24.
//

import CoreLocation

struct ToDo {
    /// 제목
    var title: String
    /// 알림 받을 위치
    var location: CLLocationCoordinate2D
    /// 위치 이름
    var locationName: String
    
    init(title: String = "",
         location: CLLocationCoordinate2D = .init(),
         locationName: String = "") {
        self.title = title
        self.location = location
        self.locationName = locationName
    }
}

extension ToDo {
    func toDictionary() -> [String: Any] {
        return [
            "title": title,
            "location": ["latitude": location.latitude, "longitude": location.longitude],
            "locationName": locationName
        ]
    }
}
