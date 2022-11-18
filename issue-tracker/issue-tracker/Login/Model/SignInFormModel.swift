//
//  SignInFormModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/17.
//

import Foundation
import RxSwift

class SignInFormModel: RequestHTTPModel {
    
    func requestSignIn(_ body: [String: String]) -> Observable<(HTTPURLResponse, String)> {
        builder.setBody(body)
        builder.setHTTPMethod("post")
        return requestObservableWithResponse(pathArray: ["members", "new", "general"])
            .map({ (response: HTTPURLResponse, data: Data) -> (HTTPURLResponse, String) in
                let nickname = HTTPResponseModel().getDecoded(from: data, as: SignInResponse.self)?.nickname
                let message = (nickname == nil) ? "회원가입이 완료되었습니다. \(nickname!) 환영합니다." : "에러가 발생하였습니다. 재시도 바랍니다."
                return (response, message)
            })
    }
}

