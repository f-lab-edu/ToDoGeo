//
//  SignInRepositoryProtocol.swift
//  ToDoGeo
//
//  Created by SUN on 6/12/24.
//

import AuthenticationServices

import RxSwift

public protocol SignInRepositoryProtocol {
    /// 애플 회원가입
    /// - Parameters:
    ///   - credential: 애플 로그인 정보
    ///   - nonce: firebase에서 필요한 nonce
    /// - Returns: 회원 정보
    public func appleSignUp(credential: ASAuthorizationAppleIDCredential, nonce: String?) -> Observable<SignInUser>
}
