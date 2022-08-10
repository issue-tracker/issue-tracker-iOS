//
//  RequestHTTPModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/02.
//

import RxSwift

enum HTTPError: Error {
    case noData
    case urlError
}

class RequestHTTPModel {
    
    var requestBuilder: RequestBuilder
    
    init(_ url: URL) {
        self.requestBuilder = RequestBuilder(requestURL: url)
    }
    
    func request(_ completionHandler: @escaping (Result<Data, Error>, URLResponse?)->Void, pathArray: [String]) {
        for path in pathArray {
            requestBuilder.setPath(path)
        }
        
        request(completionHandler)
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
    
    func requestObservable() -> Observable<Data> {
        return Observable.create { observable in
            
            guard let request = self.requestBuilder.getRequest() else {
                observable.onError(HTTPError.urlError)
                return Disposables.create()
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    observable.onError(error ?? HTTPError.noData)
                    return
                }
                
                observable.onNext(data)
                observable.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
