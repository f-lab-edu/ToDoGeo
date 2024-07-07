//
//  LocationManger.swift
//  ToDoGeo
//
//  Created by SUN on 6/16/24.
//

import CoreLocation

final class LocationManger: NSObject {
    static let shared = LocationManger()
    
    private override init() {
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    var locationManager = CLLocationManager()
    
    var authorizationStatus: CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
}

extension LocationManger {
    /// 모니터링 할 위치 등록
    /// - Parameters:
    ///   - id: 위치 id
    ///   - location: 위치 좌표
    func registerLocationForGeofence(id: String, location: CLLocationCoordinate2D) {
        var region = CLCircularRegion(center: location,
                                      radius: 100,
                                      identifier: id)
        region.notifyOnEntry = true
        
        locationManager.startUpdatingLocation()
        locationManager.startMonitoring(for: region)
    }
    
    /// 모니터링하던 위치 삭제
    /// - Parameter id: 위치 id
    func removeMoniteredLocationFromGeofence(id: String) {
        if let region = locationManager.monitoredRegions.filter({ $0.identifier == id }).first {
            locationManager.stopMonitoring(for: region)
        }
    }
}

// MARK: - CLLocationManagerDelegate
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
