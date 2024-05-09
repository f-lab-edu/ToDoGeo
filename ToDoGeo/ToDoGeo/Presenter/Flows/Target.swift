//
//  Target.swift
//  ToDoGeo
//
//  Created by SUN on 4/30/24.
//

import Foundation
import Alamofire

protocol Target: URLRequestConvertible {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var parameter: RequestParameter { get }
}

extension Target {
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = try URLRequest(url: url.appendingPathComponent(path), method: method)
        urlRequest.headers = HTTPHeaders(headers)
        
        switch parameter {
        case .queryNBody(let query, let body):
            urlRequest.url = try makeUrlWithQuery(url: urlRequest.url, query: query)
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body?.toParameter() ?? [:])
            
        case .none:
            break
        }
        return urlRequest
    }
    
    /// url에 쿼리 세팅
    private func makeUrlWithQuery(url: URL?, query: Encodable?) throws -> URL? {
        guard let url = url else {
            return nil
        }
        let queryToParameter = try query?.toParameter()
        let queryItems = queryToParameter?.compactMap({ URLQueryItem(name: $0.key, value: "\($0.value)") })
        var components = URLComponents(string: url.absoluteString)
        components?.queryItems = queryItems
        
        return components?.url
    }
}

enum RequestParameter {
    case queryNBody(_ query: Encodable?, _ parameter: Encodable?)
    case none
}

extension Encodable {
    func toParameter() throws -> Parameters {
        let data = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard let parameter = jsonObject as? Parameters else {
            throw SerializationError.invalidParameter
        }
        
        return parameter
    }
}

enum SerializationError: Error {
    case invalidParameter
}
