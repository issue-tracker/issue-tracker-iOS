//
//  RequestHTTPModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/02.
//

import Foundation

enum HTTPError: Error {
    case noData
    case noResponse
    case noURL
}

class RequestHTTPModel {
    
    var requestBuilder: RequestBuilder
    
    init(_ urlString: String) {
        self.requestBuilder = RequestBuilder(urlString: urlString)
    }
    
    func request(_ completionHandler: @escaping (Result<Data, Error>, URLResponse?)->Void) {
        
        guard let request = requestBuilder.getRequest() else {
            completionHandler(.failure(HTTPError.noURL), nil)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
        }
    }
}
