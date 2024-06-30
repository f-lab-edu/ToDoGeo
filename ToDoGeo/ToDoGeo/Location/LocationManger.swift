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
    
    /// 위치 정보 권한
    func requestAlwaysLocation() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            
        case .authorizedAlways:
            // TODO: LocationManager 위치 추적 시작
            return
            
        default:
            print("Location is not avaiable.")
        }
    }
}
