//
//  RequestHTTPTimerModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/03.
//

import RxSwift

class RequestHTTPTimerModel: RequestHTTPModel {
    private(set) var timer: Timer?
    private var timerInterval: Int
    private var timerObservable: Observable<Data>?
    
    init(timerInterval: Int, _ url: URL) {
        self.timerInterval = timerInterval
        super.init(url)
    }
    
    func setTimerInterval(_ timerInterval: Int) {
        self.timerInterval = timerInterval
    }
    
    func requestAsTimer(pathArray: [String]? = nil, _ completionHandler: @escaping (Result<Data, Error>, URLResponse?)->Void) {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: Double(timerInterval), repeats: false) { _ in
            let pathArray = pathArray ?? self.builder.pathArray
            self.request(pathArray: pathArray, completionHandler)
        }
    }
    
    /// Timer 보다 직관적으로 사용할 수 있을 것 같아서 Timer 대신 delay 연산자를 사용합니다.
    func requestAsDelayedObservable(pathArray: [String]) -> Observable<Data> {
        let result = super.requestObservable(pathArray: pathArray).delay(.seconds(timerInterval), scheduler: ConcurrentMainScheduler.instance)
        timerObservable = result // 기존에 delay 함수에 의해 이벤트를 방출하지 않고 있는 Observable을 메모리 해제 시킴.
        
        return result
    }
}
