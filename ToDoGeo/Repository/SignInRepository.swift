//
//  SignInRepository.swift
//  ToDoGeo
//
//  Created by SUN on 6/12/24.
//

import AuthenticationServices

import RxSwift
import FirebaseAuth

final class SignInRepository: SignInRepositoryProtocol {
    func appleSignUp(credential: ASAuthorizationAppleIDCredential, nonce: String?) -> Observable<SignInUser> {
        return createAppleCredential(credential: credential, nonce: nonce)
            .flatMap { oauthCredential in
                return Observable<SignInUser>.create { observer in
                    Auth.auth().signIn(with: oauthCredential) { authResult, error in
                        if let error = error {
                            observer.onError(error)
                        } else if let authResult = authResult {
                            observer.onNext(SignInUser(id: authResult.user.uid,
                                                       email: authResult.user.email ?? "",
                                                       name: authResult.user.displayName ?? ""))
                        }
                    }
                    return Disposables.create()
                }
            }
    }
    
    private func createAppleCredential(credential: ASAuthorizationAppleIDCredential,
                                       nonce: String?) -> Observable<OAuthCredential> {
        return Observable.create { observer -> Disposable in
            guard let nonce = nonce else {
                observer.onError(AppleSignInError.invalidCredential(message: "Invalid state: A login callback was received, but no login request was sent."))
                return Disposables.create()
            }
            
            guard let appleIDToken = credential.identityToken else {
                observer.onError(AppleSignInError.invalidCredential(message: "Unable to fetch identity token"))
                return Disposables.create()
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                observer.onError(AppleSignInError.invalidCredential(message: "Unable to serialize token string from data: \(appleIDToken.debugDescription)"))
                return Disposables.create()
            }
            
            observer.onNext(OAuthProvider.credential(withProviderID: "apple.com",
                                                            idToken: idTokenString,
                                                            rawNonce: nonce))
            
            return Disposables.create()
        }
     
    }
}
