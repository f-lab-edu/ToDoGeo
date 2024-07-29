//
//  LocationManger.swift
//  ToDoGeo
//
//  Created by SUN on 6/16/24.
//

import CoreLocation
import UserNotifications
import Shared

final public class LocationManger: NSObject {
    public static let shared = LocationManger()
    
    private override init() {
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
    }
    
    public var locationManager = CLLocationManager()
    
    public var authorizationStatus: CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
}

public extension LocationManger {
    /// 모니터링 할 위치 등록
    /// - Parameters:
    ///   - id: 위치 id
    ///   - location: 위치 좌표
    func registerLocationForGeofence(id: String, location: CLLocationCoordinate2D) {
        let region = CLCircularRegion(center: location,
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
    
    /// 로컬 푸쉬 기능
    /// - Parameters:
    ///   - id: 위치 id
    ///   - body: push 내용
    func pushLocationNotification(id: String,
                                  body: String) {
        let notificationCenter = UNUserNotificationCenter.current()
                
        notificationCenter.getNotificationSettings { (settings) in
            if settings.alertSetting == .enabled {
                let content = UNMutableNotificationContent()
                content.title = "ToDo 알림!"
                content.body = body
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                notificationCenter.add(request)
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManger: CLLocationManagerDelegate {
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
        case .notDetermined:
            manager.requestAlwaysAuthorization()
            
        default:
            AlertManager.shared.showInfoAlert(message: "위치 권한 설정을 항상으로 바꿔야 사용 가능 합니다.")
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        switch state {
        case .inside:
            pushLocationNotification(id: region.identifier, body: "해야 할 일이 있어요!")
            
        case .outside, .unknown:
            break
        }
    }
}
