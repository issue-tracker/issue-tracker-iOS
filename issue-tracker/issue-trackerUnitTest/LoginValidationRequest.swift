//
//  LoginValidationRequest.swift
//  issue-trackerUnitTests
//
//  Created by 백상휘 on 2022/08/08.
//

import RxSwift

enum LoginValidationCategory: String, CaseIterable {
    case nickName = "nickname"
    case loginId = "login-id"
    case email = "email"
}

class LoginValidationRequest: ModelTestableReactively {
    
    var disposables: [Disposable] = []
    let disposableLimitCount: Int = 2
    var disposeBag: DisposeBag = DisposeBag()
    
    var nextHandler: ((Data) -> Void)?
    var errorHandler: ((Error) -> Void)?
    var completedHandler: (() -> Void)?
    var disposeHandler: (() -> Void)?
    
    lazy var requestModelData: ((String, AnyObserver<Data>) -> Void)? = { param, observer in
        guard var requestBuilder = self.requestModel?.requestBuilder else { return }
        
        requestBuilder.setPath(LoginValidationCategory.allCases.randomElement()?.rawValue ?? "")
        requestBuilder.setPath(param)
        requestBuilder.setPath("exists")
        
        guard let request = requestBuilder.getRequest() else { return }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                observer.onError(error ?? HTTPError.noData)
                return
            }
            
            observer.onNext(data)
            observer.onCompleted()
        }.resume()
    }
    
    typealias ReactiveResult = Data
    typealias RequestParameter = String
    
    let requestModel: RequestHTTPModel?
    let requestTimerModel: RequestHTTPTimerModel?
    
    init() {
        if let requestURL = URL.membersApiURL {
            requestModel = RequestHTTPModel(requestURL)
            requestTimerModel = RequestHTTPTimerModel(timerInterval: 2.0, requestURL)
        } else {
            requestModel = nil
            requestTimerModel = nil
        }
    }
    
    func doTest(_ param: RequestParameter? = nil) {
        guard requestModelData != nil else {
            return
        }
        
        let disposable = requestReactive(param ?? "testParameter")
        setDisposableCount(disposable)
    }
}
