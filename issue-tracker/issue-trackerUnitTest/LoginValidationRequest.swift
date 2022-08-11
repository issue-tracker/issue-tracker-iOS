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
    
    func requestModelData(_ parameter: String, _ observer: AnyObserver<Data>) {
        guard var requestBuilder = self.requestModel?.requestBuilder else { return }
        
        requestBuilder.setPath(LoginValidationCategory.allCases.randomElement()?.rawValue ?? "")
        requestBuilder.setPath(parameter)
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
    
    func doTest(_ param: Any? = nil) {
        let parameter = param as? RequestParameter
        let disposable = requestReactive(parameter ?? "testParameter")
        setDisposableCount(disposable)
    }
}
