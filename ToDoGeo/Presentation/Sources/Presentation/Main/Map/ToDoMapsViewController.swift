//
//  ToDoMapsViewController.swift
//
//
//  Created by SUN on 7/23/24.
//

import MapKit
import UIKit
import Domain
import PinLayout
import ReactorKit
import RxCocoa
import GeoLocationManager

final class ToDoMapsViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    private let completeToDoSubject = PublishSubject<ToDo>()
    private let viewDidLoadSubject = PublishSubject<Void>()
    
    private let mapView = MKMapView()
    
    private let floatButton: UIButton = {
        let image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 24
        button.backgroundColor = UIColor(named: "mainBackground")
        return button
    }()
    
    private let locationManager = LocationManger.shared
    
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
    
    private func showCompleteToDoAlert(_ todo: ToDo) {
        let alertController = UIAlertController(title: "ToDo 완료",
                                                message: "\(todo.title)을 완료 하시겠습니까?",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "완료", style: .default) { [weak self] _ in
            self?.completeToDoSubject.onNext(todo)
        }

        let cancelAction = UIAlertAction(title: "취소", style: .default)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - override
extension ToDoMapsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        viewDidLoadSubject.onNext(())
    }
    
    override func viewDidLayoutSubviews() {
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configurationMap()
        setMapCenterToUserLocation()
    }
}

extension ToDoMapsViewController {
    func bind(reactor: ToDoMapsReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: ToDoMapsReactor) {
        completeToDoSubject.map({ ToDoMapsReactor.Action.completeToDo($0) })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
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
            let annotation = ToDoAnnotation(todo: $0,
                                            coordinate: $0.location)
            mapView.addAnnotation(annotation)
        })
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        if let annotation = annotation as? ToDoAnnotation {
            showCompleteToDoAlert(annotation.todo)
        }
    }
}
