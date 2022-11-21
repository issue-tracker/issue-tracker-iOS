//
//  SignInInputCheckModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/18.
//

import RxSwift

class SignInInputCheckModel: RequestHTTPModel {
    func requestCheck(text: String, for keyPath: PartialKeyPath<SignInFormReactor.State>) -> Observable<(HTTPURLResponse, String)> {
        var pathArray = [String]()
        
        if keyPath == \.id {
            pathArray.append(contentsOf: ["signin-id", text, "exists"])
        } else if keyPath == \.email {
            pathArray.append(contentsOf: ["email", text, "exists"])
        } else if keyPath == \.nickname {
            pathArray.append(contentsOf: ["nickname", text, "exists"])
        }
        
        return requestObservableWithResponse(pathArray: pathArray)
            .buffer(timeSpan: .seconds(2), count: 1, scheduler: ConcurrentMainScheduler.instance)
            .compactMap({return $0.first})
            .map { (response: HTTPURLResponse, data: Data) -> (HTTPURLResponse, String) in
                let validationSuccess = HTTPResponseModel().getDecoded(from: data, as: Bool.self) ?? false
                return (
                    response,
                    (validationSuccess ? "이상이 발견되지 않았습니다." : "입력값을 다시 확인해주시기 바랍니다.")
                )
            }
    }
}
