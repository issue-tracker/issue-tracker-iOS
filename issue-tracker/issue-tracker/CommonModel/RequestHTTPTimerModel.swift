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
    
    init(timerInterval: Double, _ url: URL) {
        self.timerInterval = timerInterval
        super.init(url)
    }
    
    func setTimerInterval(_ timerInterval: Double) {
        self.timerInterval = timerInterval
    }
    
    func requestAsTimer(_ completionHandler: @escaping (Result<Data, Error>, URLResponse?)->Void) {
        timer?.invalidate()
        
        let pathArray = builder.pathArray
        builder.pathArray.removeAll()
        
        timer = Timer.scheduledTimer(withTimeInterval: self.timerInterval, repeats: false) { _ in
            self.request(completionHandler, pathArray: pathArray)
        }
    }
}
