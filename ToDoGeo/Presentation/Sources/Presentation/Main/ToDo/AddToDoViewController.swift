//
//  AddToDoViewController.swift
//  ToDoGeo
//
//  Created by SUN on 4/21/24.
//

import UIKit

import PinLayout
import ReactorKit
import RxSwift
import MapKit
import GeoLocationManager

final class AddToDoViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
    private let locationSubject = PublishSubject<CLLocationCoordinate2D>()
    
    private let closeButton: UIButton = {
        let button = UIButton(frame: .init(origin: .zero, size: .init(width: 36.0, height: 36.0)))
        button.setImage(UIImage(named: "close"), for: .normal)
        
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가하기", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemGray3
        button.isEnabled = false
        button.layer.cornerRadius = 8.0
        
        return button
    }()
    
    private let locationTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "현재 위치 "
        
        return textField
    }()
    
    private let locationTextFieldErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 8.0, weight: .regular)
        label.textAlignment = .left
        label.isHidden = true
        
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "할 일을 입력해 주세요."
        
        return textField
    }()
    
    private let titleTextFieldErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 8.0, weight: .regular)
        label.textAlignment = .left
        label.isHidden = true
        
        return label
    }()
    
    private let mapView = MKMapView()
    
    private let centerPin = MKPointAnnotation()
    private let locationManager = LocationManger.shared
    
    private func addSubviews() {
        [closeButton, addButton, locationTextField, titleTextField, locationTextFieldErrorLabel, titleTextFieldErrorLabel, mapView]
            .forEach({ view.addSubview($0) })
        
        view.bringSubviewToFront(addButton)
    }
    
    private func setupLayout() {
        closeButton.pin.top(view.pin.safeArea + 16.0)
            .right(view.pin.safeArea)
            .height(56.0)
            .marginRight(16.0)
            .sizeToFit()
        
        titleTextField.pin.top(view.pin.safeArea)
            .height(40.0)
            .marginTop(50.0)
            .horizontally(16.0)
        
        titleTextFieldErrorLabel.pin.below(of: titleTextField)
            .height(10.0)
            .marginTop(2.0)
            .horizontally(20.0)
        
        locationTextField.pin.below(of: titleTextField)
            .height(40)
            .marginTop(16)
            .horizontally(16)
        
        locationTextFieldErrorLabel.pin.below(of: locationTextField)
            .height(10.0)
            .marginTop(2.0)
            .horizontally(20.0)
        
        mapView.pin.below(of: locationTextField)
            .marginTop(30.0)
            .horizontally()
            .bottom()
        
        addButton.pin
            .height(50)
            .bottom(view.pin.safeArea + 16.0)
            .horizontally(16)
        
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
    
    /// 지도에 핀 추가
    private func configurationCenterPin() {
        centerPin.coordinate = mapView.centerCoordinate
        mapView.addAnnotation(centerPin)
    }
    
    /// 지도 가운데를 사용자 위치로 초기화
    private func setMapCenterToUserLocation() {
        let userLocation = locationManager.locationManager.location?.coordinate ?? .init(latitude: 37.27, longitude: 127.43)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: userLocation, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    /// 지도 가운데에 원형 지역을 사용자 위치로 초기화
    private func setCircularResionInMap() {
        let userLocation = locationManager.locationManager.location?.coordinate ?? .init(latitude: 37.27, longitude: 127.43)
        mapView.addOverlay(MKCircle(center: userLocation, radius: 100))
    }
}

// MARK: - override
extension AddToDoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubviews()
        configurationMap()
    }
    
    override func viewDidLayoutSubviews() {
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setMapCenterToUserLocation()
        setCircularResionInMap()
    }
}

// MARK: - Binding
extension AddToDoViewController {
    func bind(reactor: AddToDoReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: AddToDoReactor) {
        closeButton.rx.tap
            .map({ AddToDoReactor.Action.didTapDismissButton })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        titleTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .skip(1)
            .map({ AddToDoReactor.Action.inputToDoTitle($0) })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        locationTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .skip(1)
            .map({ AddToDoReactor.Action.inputLocationName($0) })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .map({ AddToDoReactor.Action.didTapAddButton })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        locationSubject
            .map({ AddToDoReactor.Action.inputToDoLocation($0) })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: AddToDoReactor) {
        reactor.state
            .map({ $0.locationTextFieldError })
            .distinctUntilChanged()
            .bind { [weak self] error in
                self?.locationTextFieldErrorLabel.text = error.errorMessage
                if error == .none {
                    self?.locationTextFieldErrorLabel.isHidden = true
                } else {
                    self?.locationTextFieldErrorLabel.isHidden = false
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map({ $0.titleTextFieldError })
            .distinctUntilChanged()
            .bind { [weak self] error in
                self?.titleTextFieldErrorLabel.text = error.errorMessage
                if error == .none {
                    self?.titleTextFieldErrorLabel.isHidden = true
                } else {
                    self?.titleTextFieldErrorLabel.isHidden = false
                }
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map({ $0.isEnableAddButton })
            .distinctUntilChanged()
            .bind { [weak self] isValid in
                if isValid {
                    self?.addButton.isEnabled = true
                    self?.addButton.backgroundColor = UIColor(named: "mainBackground")
                } else {
                    self?.addButton.backgroundColor = .systemGray3
                    self?.addButton.isEnabled = false
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - MKMapViewDelegate
extension AddToDoViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let centerCoordinate = mapView.centerCoordinate
        centerPin.coordinate = centerCoordinate
        
        locationSubject.onNext(centerCoordinate)
        
        if let circleOverlay = mapView.overlays.first as? MKCircle {
            mapView.removeOverlay(circleOverlay)
            mapView.addOverlay(MKCircle(center: centerCoordinate, radius: 100))
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circleOverlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circleOverlay)
            circleRenderer.fillColor = UIColor.red.withAlphaComponent(0.5)
            circleRenderer.strokeColor = UIColor.red
            circleRenderer.lineWidth = 2
            return circleRenderer
        }
        return MKOverlayRenderer()
    }
}

