//
//  API.swift
//  ToDoGeo
//
//  Created by SUN on 4/30/24.
//

import Foundation
import Alamofire

final class API {
    static let timeOut: TimeInterval = 5.0
    
    static func makeDataRequest(_ convertible: URLRequestConvertible, interceptor: RequestInterceptor? = nil) -> DataRequest {
        let configuration = URLSessionConfiguration.af.default
        let session = Session(configuration: configuration, eventMonitors: [NetworkEventLogger()])

        return session.request(convertible, interceptor: interceptor)
    }
}

