//
//  SignInViewController.swift
//  ToDoGeo
//
//  Created by SUN on 4/21/24.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

final class SignInViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일을 입력해 주세요."
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.black.cgColor
        textField.returnKeyType = .done
        
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력해 주세요."
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.black.cgColor
        textField.returnKeyType = .done
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .gray
        button.isEnabled = false
        
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.backgroundColor = .green
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    func setupLayout() {
        view.backgroundColor = .white
        [emailTextField,
        passwordTextField,
        signInButton,
         signUpButton].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            emailTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            emailTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48.0),
            
            passwordTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            passwordTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 8.0),
            
            signInButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            signInButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16.0),
            signInButton.heightAnchor.constraint(equalToConstant: 48.0),
            
            signUpButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16.0),
            signUpButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16.0),
            signUpButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 8.0),
            signUpButton.heightAnchor.constraint(equalToConstant: 48.0)
        ])
        
    }
}

// MARK: - Binding
extension SignInViewController {
    func bind(reactor: SignInReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    // MARK: - Bind Action
    func bindAction(reactor: SignInReactor) {
        emailTextField.rx.text
            .orEmpty
            .map({ SignInReactor.Action.inputEmail(input: $0) })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        emailTextField.rx.controlEvent(.editingDidEndOnExit)
            .map({ SignInReactor.Action.didTappedDoneButtonInEmailTextField })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .map({ SignInReactor.Action.inputPassword(input: $0) })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.controlEvent(.editingDidEndOnExit)
            .map({ SignInReactor.Action.didTappedDoneButtonInPasswordTextField })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        signInButton.rx.tap
            .map({ SignInReactor.Action.didTappedSignInButton })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Bind State
    func bindState(reactor: SignInReactor) {
        reactor.state.map({ $0.isEnableSignInButton })
            .asDriver(onErrorRecover: { _ in return .never() })
            .drive(with: self, onNext: { owner, isEnabled in
                owner.signInButton.isEnabled = isEnabled
                owner.signInButton.backgroundColor = isEnabled ? .blue : .gray
            })
            .disposed(by: self.disposeBag)
        
    }
}
