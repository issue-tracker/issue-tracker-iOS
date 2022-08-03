//
//  RequestHTTPTimerModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/08/03.
//

import Foundation

class RequestHTTPTimerModel: RequestHTTPModel {
    private(set) var timer: Timer?
    private var timerInterval: TimeInterval
    private var completionHandler: ((Result<Data, Error>, URLResponse?)->Void)?
    
    init(timerInterval: Double, _ urlString: String) {
        self.timerInterval = timerInterval
        super.init(urlString)
    }
    
    func setTimerInterval(_ timerInterval: Double) {
        self.timerInterval = timerInterval
    }
    
    func requestAsTimer(_ completionHandler: @escaping (Result<Data, Error>, URLResponse?)->Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: self.timerInterval, target: self, selector: #selector(requestHTTP(_:)), userInfo: nil, repeats: false)
        self.completionHandler = completionHandler
    }
    
    @objc func requestHTTP(_ sender: Any) {
        if let completionHandler = completionHandler {
            request(completionHandler)
        }
    }
}
