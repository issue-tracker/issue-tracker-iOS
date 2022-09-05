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
    
    var builder: RequestBuilder
    
    convenience init?(_ baseURL: URL?) {
        guard let url = baseURL else {
            return nil
        }
        
        self.init(url)
    }
    
    init(_ baseURL: URL) {
        self.builder = RequestBuilder(baseURL: baseURL)
    }
    
    func request(pathArray: [String] = [], _ completionHandler: @escaping (Result<Data, Error>, URLResponse?)->Void) {
        builder.pathArray = pathArray
        request(completionHandler)
    }
    
    func requestObservable(pathArray: [String] = []) -> Observable<Data> {
        builder.pathArray = pathArray
        return requestObservable()
    }
    
    private func request(_ completionHandler: @escaping (Result<Data, Error>, URLResponse?)->Void) {
        
        guard var request = builder.getRequest() else {
            completionHandler(.failure(HTTPError.urlError), nil)
            return
        }
        
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
//        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
//            request.setValue("Authentication", forHTTPHeaderField: accessToken)
//        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completionHandler(.failure(error ?? HTTPError.noData), response)
                return
            }
            
            completionHandler(.success(data), response)
            
        }.resume()
    }
    
    private func requestObservable() -> Observable<Data> {
        return Observable.create { observable in
            
            guard let request = self.builder.getRequest() else {
                observable.onError(HTTPError.urlError)
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    observable.onError(error ?? HTTPError.noData)
                    return
                }
                
                observable.onNext(data)
                observable.onCompleted()
            }.resume()
            
            return Disposables.create()
        }
    }
}
