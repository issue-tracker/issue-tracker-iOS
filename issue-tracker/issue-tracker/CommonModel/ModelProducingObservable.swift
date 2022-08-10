//
//  ModelProducingObservable.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/10.
//

import RxSwift

/// Observable을 생산하는 모델을 만들기 위한 프로토콜입니다.
///
/// 1. Observable 생산
/// 2. next, error, completed Event 방출 시 실행할 handler 저장해둠.
/// 3. Disposable 생산. 이 메소드는 자동으로 각 handler 를 작동시킴. 이 메소드를 실행할 때 만약 handler 를 넘겨주면 새로운 handler 로 인식하고 교체한다.
protocol ModelProducingObservable {
    /// 모델이 next Event 방출 시 반환하는 데이터 타입
    associatedtype ReactiveResult
    /// 모델이 데이터를 얻기 위해 호출하는 함수의 파라미터
    associatedtype RequestParameter
    
    // 각 Event에 대한 Handler들
    var nextHandler: (ReactiveResult) -> Void { get set }
    var errorHandler: (Error) -> Void { get set }
    var completedHandler: () -> Void { get set }
    
    /// 모델이 데이터를 얻기 위한 function.
    ///
    /// RequestParameter 타입을 넘겨주어야 한다.
    func requestModelData(_ parameter: RequestParameter, _ observer: AnyObserver<ReactiveResult>)
    /// requestModelData를 실행하고 결과값을 방출하는 Observable을 반환한다.
    func getObservable() -> Observable<ReactiveResult>
    /// Observable을 이용해서 request 한 결과물에 대한 각 handler를 실행하도록 구독까지 진행한다. override 는 권장되지 않습니다.
    /// - Returns: Disposable. DisposeBag 처리 필요.
    func requestReactive(_ parameter: RequestParameter) -> Disposable
    /// Observable을 이용해서 request 한 결과물에 대한 각 handler를 실행하도록 구독까지 진행한다. override 는 권장되지 않습니다.
    /// - Parameter nextHandler: next 이벤트가 실행될 경우 실행할 handler. 기존의 것과 대체된다.
    /// - Parameter errorHandler: error 이벤트가 실행될 경우 실행할 handler. 기존의 것과 대체된다.
    /// - Parameter completedHandler: completed 이벤트가 실행될 경우 실행할 handler. 기존의 것과 대체된다.
    /// - Returns: Disposable. DisposeBag 처리 필요.
    func requestReactive(_ parameter: RequestParameter, _ nextHandler: ((ReactiveResult)->Void)?, _ errorHandler: ((Error)->Void)?, _ completedHandler: (()->Void)?) -> Disposable
}

extension ModelProducingObservable {
    
    func requestReactive() -> Disposable {
        getObservable().subscribe(
            onNext: nextHandler,
            onError: errorHandler,
            onCompleted: completedHandler
        )
    }
    
    mutating func requestReactive(_ parameter: RequestParameter, _ nextHandler: ((ReactiveResult)->Void)? = nil, _ errorHandler: ((Error)->Void)? = nil, _ completedHandler: (()->Void)? = nil) -> Disposable {
        if let nextHandler = nextHandler {
            self.nextHandler = nextHandler
        }
        if let errorHandler = errorHandler {
            self.errorHandler = errorHandler
        }
        if let completedHandler = completedHandler {
            self.completedHandler = completedHandler
        }
        
        return requestReactive(parameter)
    }
}
