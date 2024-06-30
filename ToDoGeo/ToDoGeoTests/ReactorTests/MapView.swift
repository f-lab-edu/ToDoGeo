//
//  MapView.swift
//  ToDoGeo
//
//  Created by SUN on 6/30/24.
//

import UIKit
import MapKit

import PinLayout

final class MapViewController: UIViewController {
    private let mapView = MKMapView()
    
    private let centerPin = MKPointAnnotation()
    private let locationManager = LocationManger.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(mapView)
        
        mapView.pin.all()
    }
    
    private func configurationMap() {
        mapView.delegate = self
        mapView.preferredConfiguration = MKStandardMapConfiguration()
        
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        mapView.showsCompass = true
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        configurationCenterPin()
    }
    
    private func configurationCenterPin() {
        centerPin.coordinate = mapView.centerCoordinate
        mapView.addAnnotation(centerPin)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            // 맵뷰의 가운데 위치 업데이트
            let centerCoordinate = mapView.centerCoordinate
            centerPin.coordinate = centerCoordinate
            print("Center Coordinate: \(centerCoordinate.latitude), \(centerCoordinate.longitude)")
        }
}
