//
//  ToDoMapsViewController.swift
//  ToDoGeo
//
//  Created by SUN on 7/13/24.
//

import MapKit
import UIKit

import PinLayout
import ReactorKit
import RxCocoa

final class ToDoMapsViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    private let viewDidLoadSubject = PublishSubject<Void>()
    
    private let mapView = MKMapView()
    
    private let floatButton: UIButton = {
        let image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 24
        button.backgroundColor = .mainBackground
        return button
    }()
    
    private let locationManager = LocationManger.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        viewDidLoadSubject.onNext(())
    }
    
    override func viewDidLayoutSubviews() {
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configurationMap()
        setMapCenterToUserLocation()
    }
    
    private func addSubviews() {
        [mapView, floatButton]
            .forEach({ view.addSubview($0) })
        
        view.bringSubviewToFront(floatButton)
    }
    
    private func setupLayout() {
        mapView.pin.all()
        
        floatButton.pin.bottom(view.pin.safeArea + 16.0)
            .right(16.0)
            .width(48.0)
            .height(48.0)
    }
    
    private func configurationMap() {
        mapView.delegate = self
        mapView.preferredConfiguration = MKStandardMapConfiguration()
        
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isPitchEnabled = true
        mapView.isRotateEnabled = true
        mapView.showsCompass = true
        mapView.showsUserLocation = true
        
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    
    /// 지도 가운데를 사용자 위치로 초기화
    private func setMapCenterToUserLocation() {
        let userLocation = locationManager.locationManager.location?.coordinate ?? .init(latitude: 37.27, longitude: 127.43)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: userLocation, span: span)
        mapView.setRegion(region, animated: true)
    }
}

extension ToDoMapsViewController {
    func bind(reactor: ToDoMapsReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ToDoMapsReactor) {
        viewDidLoadSubject.map({ ToDoMapsReactor.Action.viewDidLoad })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        floatButton.rx.tap
            .map({ ToDoMapsReactor.Action.didTapFloatButton })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: ToDoMapsReactor) {
        reactor.state
            .map({ $0.todos })
            .bind { [weak self] todos in
                self?.addToDoAnnotaions(todos)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - MKMapViewDelegate
extension ToDoMapsViewController: MKMapViewDelegate {
    private func addToDoAnnotaions(_ todos: [ToDo]) {
        mapView.removeAnnotations(mapView.annotations)
        todos.forEach({
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: $0.location.latitude,
                                                           longitude: $0.location.longitude)
            annotation.title = $0.title
            annotation.subtitle = $0.locationName
            mapView.addAnnotation(annotation)
        })
    }
}
