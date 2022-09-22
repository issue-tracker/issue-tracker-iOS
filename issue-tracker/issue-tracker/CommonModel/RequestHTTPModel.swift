//
//  RequestHTTPModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/02.
//

import RxSwift
import RxCocoa

enum HTTPError: Error {
    case noData
    case urlError
    case createRequestFailed
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
    
    func request(_ urlRequest: URLRequest, pathArray: [String] = [], _ completionHandler: @escaping (Result<Data, Error>, URLResponse?)->Void) {
        request(urlRequest, completionHandler)
    }
    
    func request(pathArray: [String] = [], _ completionHandler: @escaping (Result<Data, Error>, URLResponse?)->Void) {
        builder.pathArray = pathArray
        request(completionHandler)
    }
    
    func requestObservable(pathArray: [String] = []) -> Observable<Data> {
        builder.pathArray = pathArray
        return requestObservable()
    }
    
    func requestObservable(_ request: URLRequest, pathArray: [String] = []) -> Observable<Data> {
        requestObservable(request)
    }
    
    /// 셋팅된 정보를 토대로 HTTP Request 를 한 후 응답이 오면 파라미터로 전달된 Clousre를 실행합니다.
    ///
    /// 모든 Request 이후엔 Context-Path, HTTP Body/Method/Header, URL Queries 모두 초기화 됩니다.
    private func request(_ completionHandler: @escaping (Result<Data, Error>, URLResponse?)->Void) {
        
        guard let request = builder.getRequest() else {
            completionHandler(.failure(HTTPError.urlError), nil)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completionHandler(.failure(error ?? HTTPError.noData), response)
                return
            }
            
            completionHandler(.success(data), response)
            
        }.resume()
    }
    
    /// 직접 URLRequest 를 전달하고 completionHandler 를 실행시킵니다.
    ///
    /// 모든 Request 이후엔 Context-Path, HTTP Body/Method/Header, URL Queries 모두 초기화 됩니다.
    private func request(_ request: URLRequest, _ completionHandler: @escaping (Result<Data, Error>, URLResponse?)->Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completionHandler(.failure(error ?? HTTPError.noData), response)
                return
            }
            
            completionHandler(.success(data), response)
            
        }.resume()
    }
    
    /// 셋팅된 정보를 토대로 HTTP Request 를 한 후 응답이 오면 이벤트를 방출하는 Observable 을 생성하고 반환합니다.
    ///
    /// 모든 Request 이후엔 Context-Path, HTTP Body/Method/Header, URL Queries 모두 초기화 됩니다.
    private func requestObservable() -> Observable<Data> {
        guard let request = self.builder.getRequest() else {
            return Observable.create { observer in
                let disposables = Disposables.create()
                observer.onError(HTTPError.createRequestFailed)
                return disposables
            }
        }
        
        return URLSession.shared.rx.data(request: request)
    }
    
    /// 직접 URLRequest 를 전달하고 Response에 따라 이벤트를 방출하는 Observable 을 생성하고 반환합니다.
    ///
    /// 모든 Request 이후엔 Context-Path, HTTP Body/Method/Header, URL Queries 모두 초기화 됩니다.
    private func requestObservable(_ request: URLRequest) -> Observable<Data> {
        return URLSession.shared.rx.data(request: request)
    }
}
