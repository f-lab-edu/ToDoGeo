//
//  SignInReactor.swift
//  ToDoGeo
//
//  Created by SUN on 4/21/24.
//

import AuthenticationServices
import CryptoKit

import FirebaseAuth
import ReactorKit
import RxFlow
import RxCocoa
import Domain
import Shared

final class SignInReactor: NSObject, Reactor, Stepper {
    var disposeBag = DisposeBag()
    
    var steps: PublishRelay<Step>
    fileprivate var currentNonce: String?
    var signInUseCase: SignInUseCaseProtocol
    var initialState: State
    
    init(signInUseCase: SignInUseCaseProtocol,
         initialState: State) {
        self.signInUseCase = signInUseCase
        self.initialState = initialState
        self.steps = PublishRelay<Step>()
    }
    
    struct State {
       
    }
    
    enum Action {
        /// 애플 로그인 버튼 클릭
        case didTapAppleSignInButton
    }
    
    enum Mutation {

    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .didTapAppleSignInButton:
            startSignInWithAppleFlow()
            return .empty()
        }
    }
}

extension SignInReactor {
    func requestAppleSignInToFirebase(credential: ASAuthorizationAppleIDCredential) {
        signInUseCase.appleSignUp(credential: credential, nonce: currentNonce)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] signInUser in
                Utility.save(key: Constant.userID, value: signInUser.id)
                Utility.save(key: Constant.userName, value: signInUser.name)
                Utility.save(key: Constant.userEmail, value: signInUser.email)
                self?.steps.accept(AppStep.toDoRequired)
            } onError: { error in
                AlertManager.shared.showInfoAlert(message: error.localizedDescription)
            }
            .disposed(by: disposeBag)

    }
}

// MARK: - apple sign in delegate
extension SignInReactor: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.keyWindow!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            requestAppleSignInToFirebase(credential: credential)
        }
    }
    
    /// 애플 로그인 요청
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        guard let inputData = input.data(using: .utf8) else {
            fatalError("Unable to convert string to data using UTF-8 encoding")
        }
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}
