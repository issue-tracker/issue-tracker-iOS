//
//  LoginValidationRequest.swift
//  issue-trackerUnitTests
//
//  Created by 백상휘 on 2022/08/08.
//

import Foundation

enum LoginValidationCategory: String {
    case nickName = "nickname"
    case loginId = "login-id"
    case email = "email"
}

class LoginValidationRequest {
    private let requestModel: RequestHTTPModel?
    
    init() {
        if let requestURL = URL.membersApiURL {
            requestModel = RequestHTTPModel(requestURL)
        } else {
            requestModel = nil
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
}
