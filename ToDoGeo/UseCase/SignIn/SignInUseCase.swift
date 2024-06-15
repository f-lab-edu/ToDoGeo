//
//  SignInUseCase.swift
//  ToDoGeo
//
//  Created by SUN on 6/12/24.
//

import AuthenticationServices

import RxSwift

final class SignInUseCase {
    private let signInRepository: SignInRepositoryProtocol
    
    init(signInRepository: SignInRepositoryProtocol) {
        self.signInRepository = signInRepository
    }
}

extension SignInUseCase: SignInUseCaseProtocol {
    /// 애플 회원가입
    /// - Parameters:
    ///   - credential: 애플 로그인 정보
    ///   - nonce: firebase에서 필요한 nonce
    /// - Returns: 회원 정보
    func appleSignUp(credential: ASAuthorizationAppleIDCredential, nonce: String?) -> Observable<SignInUser> {
        return signInRepository.appleSignUp(credential: credential, nonce: nonce)
    }
}

