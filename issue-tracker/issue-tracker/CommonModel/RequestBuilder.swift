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
    private var urlContainer: URL
    private(set) var requestURL: URL
    private(set) var bodyDictionary = [String: String]()
    private(set) var pathArray = [String]()
    
    private let encoder = JSONEncoder()
    
    init(requestURL: URL) {
        self.requestURL = requestURL
        self.urlContainer = requestURL
    }
    
    var httpBody: Data? {
        try? encoder.encode(bodyDictionary)
    }
    
    mutating func setBody(_ key: String, value: String) {
        bodyDictionary[key] = value
    }
    
    mutating func setPath(_ path: String) {
        pathArray.append(path)
    }
    
    mutating func getRequest() -> URLRequest? {
        
        defer {
            requestURL = urlContainer
            pathArray.removeAll()
        }
        
        for path in pathArray {
            requestURL.appendPathComponent(path)
        }
        
        return URLRequest(url: requestURL)
    }
    
    mutating func removeAllPath() {
        pathArray.removeAll()
    }
    
    func getReservedHeaderFieldKey(query: String) -> String? {
        let queryString = query.lowercased()
        let index = allHeaderFields.firstIndex(where: { $0.lowercased() == queryString})
        
        if let index = index {
            return allHeaderFields[index]
        }
        
        return nil
    }
}


