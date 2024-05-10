//
//  SignInViewController.swift
//  ToDoGeo
//
//  Created by SUN on 4/21/24.
//

import UIKit

import PinLayout
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
        
        addSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        setupLayout()
    }
    
    private func addSubviews() {
        view.backgroundColor = .white
        [emailTextField, passwordTextField, signInButton, signUpButton].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
    }
    
    private func setupLayout() {
        emailTextField.pin.top(view.safeAreaInsets.top + 48.0)
            .horizontally(16.0)
        
        passwordTextField.pin.below(of: emailTextField)
            .horizontally(16.0)
            .marginTop(8.0)
        
        signUpButton.pin.below(of: passwordTextField)
            .horizontally(16.0)
            .marginTop(8.0)
            .height(48.0)
        
        signInButton.pin.below(of: signUpButton)
            .horizontally(16.0)
            .marginTop(8.0)
            .height(48.0)
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
