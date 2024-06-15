//
//  SignInViewController.swift
//  ToDoGeo
//
//  Created by SUN on 4/21/24.
//

import AuthenticationServices
import UIKit

import CryptoKit
import PinLayout
import ReactorKit
import RxSwift
import RxCocoa

final class SignInViewController: UIViewController, View {
    var disposeBag = DisposeBag()
   
    private let appleSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In with Apple", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.backgroundColor = .black
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
        [appleSignInButton].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
    }
    
    private func setupLayout() {
        appleSignInButton.pin.bottom(view.pin.safeArea)
            .horizontally(16.0)
            .height(48.0)
            .marginBottom(16.0)
    }
}

// MARK: - Binding
extension SignInViewController {
    func bind(reactor: SignInReactor) {
        bindAction(reactor: reactor)
    }
    
    // MARK: - Bind Action
    func bindAction(reactor: SignInReactor) {
        appleSignInButton.rx.tap
            .map({ SignInReactor.Action.didTapAppleSignInButton })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}
