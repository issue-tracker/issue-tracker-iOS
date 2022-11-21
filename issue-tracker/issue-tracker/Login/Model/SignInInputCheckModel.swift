//
//  SignInInputCheckModel.swift
//  issue-tracker
//
//  Created by 백상휘 on 2022/11/18.
//

import RxSwift

class SignInInputCheckModel: RequestHTTPModel {
    
    /// Observable that request check API references this value when buffer inputs. Precisely, it used in buffer operator.
    private(set) var bufferSeconds: Int = 2
    
    convenience init(_ baseURL: URL, bufferSeconds: Int) {
        self.init(baseURL)
        
        if bufferSeconds > 0 {
            self.bufferSeconds = bufferSeconds
        }
    }
    
    func requestCheck(text: String, for keyPath: PartialKeyPath<SignInFormReactor.State>) -> Observable<(response: HTTPURLResponse, isDuplicate: Bool)> {
        var pathArray = [String]()
        
        if keyPath == \.id {
            pathArray.append(contentsOf: ["signin-id", text, "exists"])
        } else if keyPath == \.email {
            pathArray.append(contentsOf: ["email", text, "exists"])
        } else if keyPath == \.nickname {
            pathArray.append(contentsOf: ["nickname", text, "exists"])
        }
        
        return requestObservableWithResponse(pathArray: pathArray)
            .buffer(timeSpan: .seconds(bufferSeconds), count: 1, scheduler: ConcurrentMainScheduler.instance)
            .compactMap({return $0.first})
            .map { (response: HTTPURLResponse, data: Data) -> (response: HTTPURLResponse, isDuplicate: Bool) in
                return (
                    response: response,
                    isDuplicate: HTTPResponseModel().getDecoded(from: data, as: Bool.self) ?? false
                )
            }
    }
}
