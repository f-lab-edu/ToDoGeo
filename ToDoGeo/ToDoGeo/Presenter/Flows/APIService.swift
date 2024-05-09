//
//  APIService.swift
//  ToDoGeo
//
//  Created by SUN on 4/30/24.
//

import Alamofire
import RxSwift

protocol APIServiceProtocol {
    func request<Target: URLRequestConvertible, Response: Codable>(request: Target, response: Response.Type) -> Observable<Response>
}

final class APIService: APIServiceProtocol {
    /// api request 함수
    func request<Target: URLRequestConvertible, Response: Codable>(request: Target, response: Response.Type) -> Observable<Response> {
        return Observable.create({ observer -> Disposable in
            API.requestToAlamofire(request)
                .validate()
                .responseDecodable(of: response.self) { [weak self] response in
                    self?.completeHandler(observer: observer, response: response)
                }
            return Disposables.create()
        })
    }
    
    /// api response 처리 함수
    func completeHandler<T: Decodable>(observer: AnyObserver<T>, response: AFDataResponse<T>) {
        switch response.result {
        case .success(let data):
            observer.onNext(data)
            
        case .failure(let error):
            observer.onError(error)
        }
    }
}

