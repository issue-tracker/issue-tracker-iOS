//
//  RequestHTTPModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/02.
//

import Foundation

enum HTTPError: Error {
    case noData
    case urlError
}

class RequestHTTPModel {
    
    var requestBuilder: RequestBuilder
    
    init(_ urlString: String) {
        self.requestBuilder = RequestBuilder(urlString: urlString)
    }
    
    func request(_ completionHandler: @escaping (Result<Data, Error>, URLResponse?)->Void) {
        
        guard let request = requestBuilder.getRequest() else {
            completionHandler(.failure(HTTPError.urlError), nil)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completionHandler(.failure(error), response)
                } else {
                    completionHandler(.failure(HTTPError.noData), response)
                }
                
                return
            }
            
            completionHandler(.success(data), response)
            
        }.resume()
    }
}
