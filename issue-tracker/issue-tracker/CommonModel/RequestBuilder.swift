//
//  RequestBuilder.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/02.
//

import Foundation

/// 지정한 파라미터, HTTP Method 등의 데이터를 토대로 URLRequest를 생성하는 구조체.
/// 상황에 따라 클래스가 될 수도 있음.
struct RequestBuilder {
    
    private let allHeaderFields = ["Content-Length",
                                   "Authorization",
                                   "Connection",
                                   "Host",
                                   "Proxy-Authenticate",
                                   "Proxy-Authorization",
                                   "WWW-Authenticate"]
    private let allHTTPMethods = ["GET", "POST", "PUT", "DELETE"]
    private let encoder = JSONEncoder()
    private let baseURL: URL
    
    private(set) var httpMethod: String?
    private var customHeaderField = [String: String]()
    
    var pathArray = [String]()
    var httpBody: Data?
    
    init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    mutating func setBody<T: Encodable>(_ body: T)  { // 참조 : 
        self.httpBody = try? JSONEncoder().encode(body)
    }
    
    mutating func setBody(_ body: [String: String]) {
        self.httpBody = try? JSONSerialization.data(withJSONObject: body)
    }
    
    mutating func setHTTPMethod(_ method: String) {
        let query = method.lowercased()
        allHTTPMethods.forEach { methodName in
            if methodName.lowercased() == query {
                self.httpMethod = methodName
            }
        }
    }
    
    mutating func getRequest() -> URLRequest? {
        var requestURL = baseURL
        for path in pathArray {
            requestURL.appendPathComponent(path)
        }
        
        var request = URLRequest(url: requestURL)
        request.httpBody = httpBody
        request.httpMethod = httpMethod
        
        pathArray.removeAll()
        
        for field in customHeaderField {
            request.setValue(field.value, forHTTPHeaderField: field.key)
        }
        
        return request
    }
    
    private func getReservedHeaderFieldKey(query: String) -> String? {
        let queryString = query.lowercased()
        let index = allHeaderFields.firstIndex(where: { $0.lowercased() == queryString})
        
        if let index = index {
            return allHeaderFields[index]
        }
        
        return nil
    }
    
    @discardableResult
    mutating func setContentTypeToJson() -> Bool {
        guard let headerFieldKey = getReservedHeaderFieldKey(query: "content-type") else {
            return false
        }
        
        customHeaderField[headerFieldKey] = "application/json; charset=utf-8"
        return true
    }
}
