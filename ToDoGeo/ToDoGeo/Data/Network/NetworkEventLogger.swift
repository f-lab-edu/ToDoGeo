//
//  NetworkEventLogger.swift
//  ToDoGeo
//
//  Created by SUN on 4/28/24.
//

import Foundation
import Alamofire

/// 네트워크 이벤트 로그 출력
final class NetworkEventLogger: EventMonitor {
    
    let queue = DispatchQueue(label: "networkLogger")
    
    /// request 관련 로그 출력
    func requestDidFinish(_ request: Request) {
        debugPrint("======= 🛰 NETWORK Reqeust LOG START =======")
        debugPrint(request.description)
        debugPrint("URL: " + (request.request?.url?.absoluteString ?? ""))
        debugPrint("Method: " + (request.request?.httpMethod ?? ""))
        debugPrint("Headers: " + "\(request.request?.allHTTPHeaderFields ?? [:])")
        debugPrint("Body: " + (request.request?.httpBody?.toPrettyPrintedString ?? ""))
        debugPrint("======= 🛰 NETWORK Reqeust LOG End =======")
        
    }
    
    /// response 관련 로그 출력
    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        debugPrint("🛰 NETWORK Response LOG START")
        debugPrint("URL: " + (request.request?.url?.absoluteString ?? ""))
        debugPrint("Result: " + "\(response.result)")
        debugPrint("StatusCode: " + "\(response.response?.statusCode ?? 0)")
        debugPrint("Data: \(response.data?.toPrettyPrintedString ?? "")")
        debugPrint("======= 🛰 NETWORK Response LOG End =======")
    }
}

extension Data {
    var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }
        return prettyPrintedString as String
    }
}
