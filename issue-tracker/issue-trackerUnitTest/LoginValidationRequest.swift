//
//  LoginValidationRequest.swift
//  issue-trackerUnitTests
//
//  Created by 백상휘 on 2022/08/08.
//

import Foundation

enum LoginValidationCategory: String, CaseIterable {
    case nickName = "nickname"
    case loginId = "login-id"
    case email = "email"
}

class LoginValidationRequest {
    private let requestModel: RequestHTTPModel?
    private let requestTimerModel: RequestHTTPTimerModel?
    
    init() {
        if let requestURL = URL.membersApiURL {
            requestModel = RequestHTTPModel(requestURL)
            requestTimerModel = RequestHTTPTimerModel(timerInterval: 2.0, requestURL)
        } else {
            requestModel = nil
            requestTimerModel = nil
        }
    }
    
    func testValidate(category: LoginValidationCategory, _ sentence: String, _ completionHandler: @escaping (Bool?) -> Void) {
        
        requestModel?.requestBuilder.setPath(category.rawValue)
        requestModel?.requestBuilder.setPath(sentence)
        requestModel?.requestBuilder.setPath("exists")
        
        requestModel?.request({ result, response in
            if let data = try? result.get() {
                completionHandler(try? JSONDecoder().decode(Bool.self, from: data))
            } else {
                completionHandler(nil)
            }
        })
    }
    
    func randomInputTest(_ input: [String], _ completionHandler: @escaping (Bool?) -> Void) {
        var sentence = ""
        var count = 0
        
        var interval: Double {
            Double.random(in: 0.0...3.0)
        }
        
        let customTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] timer in
            count += 1
            
            sentence += input.randomElement() ?? ""
            
            self?.requestTimerModel?.requestBuilder.setPath(LoginValidationCategory.allCases.randomElement()?.rawValue ?? "")
            self?.requestTimerModel?.requestBuilder.setPath(sentence)
            self?.requestTimerModel?.requestBuilder.setPath("exists")
            
            print(sentence, Date())
            
            self?.requestTimerModel?.requestAsTimer({ result, response in
                print("success", sentence)
                sentence = ""
                if let data = try? result.get() {
                    completionHandler(try? JSONDecoder().decode(Bool.self, from: data))
                } else {
                    completionHandler(nil)
                }
            })
            
            if count == input.count {
                timer.invalidate()
            }
        }
        
        customTimer.fire()
    }
}
