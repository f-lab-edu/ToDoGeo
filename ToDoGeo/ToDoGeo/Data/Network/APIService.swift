//
//  APIService.swift
//  ToDoGeo
//
//  Created by SUN on 4/28/24.
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
            API.makeDataRequest(request)
                .validate()
                .responseDecodable(of: response.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            
            return Disposables.create()
        })
    }
    
    
}
