//
//  Target.swift
//  ToDoGeo
//
//  Created by SUN on 4/27/24.
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
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.headers = HTTPHeaders(headers)
        
        switch parameter {
        case .query(let query):
            let queryToParameter = query?.toParameter()
            let queryItems = queryToParameter?.compactMap({ URLQueryItem(name: $0.key, value: "\($0.value)") })
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryItems
            urlRequest.url = components?.url
            
        case .body(let body):
            let parameter = body?.toParameter()
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameter ?? [:])
            
        case .queryNBody(let query, let body):
            let queryToParameter = query?.toParameter()
            let queryItems = queryToParameter?.compactMap({ URLQueryItem(name: $0.key, value: "\($0.value)") })
            var components = URLComponents(string: url.appendingPathComponent(path).absoluteString)
            components?.queryItems = queryItems
            urlRequest.url = components?.url
            
            let parameter = body?.toParameter()
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameter ?? [:])
            
        case .none:
            break
        }
        
        return urlRequest
    }
}

enum RequestParameter {
    case query(_ query: Encodable?)
    case body(_ parameter: Encodable?)
    case queryNBody(_ query: Encodable?, _ parameter: Encodable?)
    case none
}

extension Encodable {
    func toParameter() -> Parameters {
        do {
            guard let data = try? JSONEncoder().encode(self),
                  let parameter = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? Parameters else { return Parameters() }
            return parameter
        } catch(let error) {
            debugPrint(String(format: "[Codable encodeJsonError: %@]", error.localizedDescription))
            return Parameters()
        }
    }
}
