//
//  LocationManger.swift
//  ToDoGeo
//
//  Created by SUN on 6/16/24.
//

import CoreLocation

final class LocationManger: NSObject {
    static let shared = LocationManger()
    
    private override init() {}
    
    var locationManager = CLLocationManager()
    
    var authorizationStatus: CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
}

extension LocationManger: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        case .notDetermined:
            manager.requestAlwaysAuthorization()
            
        default:
            AlertManager.shared.showInfoAlert(message: "위치 권한 설정을 항상으로 바꿔야 사용 가능 합니다.")
        }
    }
}
