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

final class AddToDoViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
    private let closeButton: UIButton = {
        let button = UIButton(frame: .init(origin: .zero, size: .init(width: 36.0, height: 36.0)))
        button.setImage(UIImage(named: "close"), for: .normal)
        
        return button
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("추가하기", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .mainBackground
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
        label.textColor = .red
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
        label.textColor = .red
        label.font = .systemFont(ofSize: 8.0, weight: .regular)
        label.textAlignment = .left
        label.isHidden = true
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        setupLayout()
    }
    
    private func addSubviews() {
        [closeButton, addButton, locationTextField, titleTextField, locationTextFieldErrorLabel, titleTextFieldErrorLabel]
            .forEach({ view.addSubview($0) })
    }
    
    private func setupLayout() {
        closeButton.pin.topRight()
            .height(56.0)
            .margin(16)
            .sizeToFit()
                
        titleTextField.pin.top(view.pin.safeArea)
            .height(40)
            .marginTop(20)
            .horizontally(16)
        
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
        
        addButton.pin
            .height(50)
            .bottom(16)
            .horizontally(16)

    }
}

// MARK: - Binding
extension AddToDoViewController {
    func bind(reactor: AddToDoReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: AddToDoReactor) {
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
        
        // TODO: 위치 입력 기능 추가
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
    }
}
