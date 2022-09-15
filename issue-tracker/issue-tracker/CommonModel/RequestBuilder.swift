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
                                   "WWW-Authenticate",
                                   "Content-Type"]
    private let allHTTPMethods = ["GET", "POST", "PUT", "DELETE"]
    private let encoder = JSONEncoder()
    let baseURL: URL
    
    private(set) var httpMethod: String?
    private var customHeaderField = [String: String]()
    private var urlQueries = [String: String]()
    
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
    
    mutating func setURLQuery(_ queries: [String: String]) {
        for query in queries {
            urlQueries[query.key] = query.value
        }
    }
    
    /// 셋팅된 정보를 이용해 URLRequest 를 만듭니다.
    ///
    /// 모든 Request 이후엔 Context-Path, HTTP Body/Method/Header, URL Queries 모두 초기화 됩니다.
    mutating func getRequest() -> URLRequest? {
        var requestURL = baseURL
        
        if urlQueries.count > 0, var comp = URLComponents(url: requestURL, resolvingAgainstBaseURL: false) {
            
            comp.queryItems = urlQueries.map({
                URLQueryItem(name: $0.key, value: $0.value)
            })
            
            if let url = comp.url {
                requestURL = url
            }
        }
        
        for path in pathArray {
            requestURL.appendPathComponent(path)
        }
        pathArray.removeAll()
        
        var request = URLRequest(url: requestURL)
        
        request.httpBody = httpBody
        httpBody = nil
        
        request.httpMethod = httpMethod ?? "GET"
        httpMethod = nil
        
        setHeader(key: "content-type", value: "application/json")
        for field in customHeaderField {
            request.setValue(field.value, forHTTPHeaderField: field.key)
        }
        
        customHeaderField.removeAll()
        
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
    
    mutating func setHeader(key: String, value: String) {
        guard let headerFieldKey = getReservedHeaderFieldKey(query: key) else {
            return
        }
        
        customHeaderField[headerFieldKey] = value
    }
}
