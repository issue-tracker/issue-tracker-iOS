//
//  SignInFormModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/17.
//

import Foundation
import RxSwift

typealias SignInResponseResult = (result: Bool, message: String)

class SignInFormModel: RequestHTTPModel {
    
    private(set) var timer: Timer?
    
    func requestSignIn(_ body: [String: String]) -> Observable<SignInResponseResult> {
        builder.setBody(body)
        builder.setHTTPMethod("post")
        return requestObservable(pathArray: ["members", "new", "general"])
            .map({ data -> (result: Bool, message: String) in
                let model = HTTPResponseModel()
                let signInResponse = model.getDecoded(from: data, as: SignInResponse.self)
                
                if let signInResponse {
                    return (result: true, message: "회원가입이 완료되었습니다. \(signInResponse.nickname) 환영합니다!")
                } else {
                    return (result: false, message: model.getMessageResponse(from: data) ?? "에러가 발생하였습니다. 재시도 바랍니다.")
                }
            })
    }
    
    func requestCheck(text: String, for keyPath: PartialKeyPath<SignInFormReactor.State>) -> Observable<SignInResponseResult> {
        var url: URL?
        
        if keyPath == \.id {
            url = URL.membersApiURL?.appendingPathExtension("signin-id").appendingPathExtension(text)
        } else if keyPath == \.email {
            url = URL.membersApiURL?.appendingPathExtension("email").appendingPathExtension(text)
        } else if keyPath == \.nickname {
            url = URL.membersApiURL?.appendingPathExtension("nickname").appendingPathExtension(text)
        }
        
        guard var url else { return .empty() }
        url.appendPathExtension("exists")
        
        return requestObservableWithResponse()
            .delay(.seconds(2), scheduler: ConcurrentMainScheduler.instance)
            .map { (response: HTTPURLResponse, data: Data) in
                let validationSuccess = HTTPResponseModel().getDecoded(from: data, as: Bool.self) ?? false
                return (result: 200..<300 ~= response.statusCode, message: validationSuccess ? "입력값을 다시 확인해주시기 바랍니다." : "이상이 발견되지 않았습니다.")
            }
    }
}


