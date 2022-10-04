//
//  issue_trackerUnitTest_LoginSignIn.swift
//  issue-trackerUnitTests
//
//  Created by 백상휘 on 2022/10/04.
//

import XCTest
import RxSwift

class issue_trackerUnitTest_LoginSignIn: XCTestCase {
    
    let disposeBag = DisposeBag()
    let model = LoginRequestHTTPModel(URL.apiURL ?? URL(string: ""))
    var expect: XCTestExpectation!
    
    override func setUp() async throws {
        expect = XCTestExpectation()
    }
    
    func test_requestLogin() throws {
        model?.requestLogin(id: "testios", password: "12341234")
            .subscribe(onSuccess: { [weak self] response in
                self?.expect.fulfill()
            }, onFailure: { error in
                let responseError = error as? ErrorResponseBody
                if responseError?.isSuccess() ?? false {
                    self.expect.fulfill()
                } else {
                    XCTFail("HTTPError. \(responseError?.localizedDescription ?? LoginRequestHTTPModel.defaultErrorMessage)")
                }
            })
            .disposed(by: disposeBag)
        
        wait(for: [expect], timeout: 3.0)
    }
                                      
    func test_loginTest() throws {
        model?.loginTest()
            .subscribe(onSuccess: { resultId in
                self.expect.fulfill()
            }, onFailure: { error in
                let responseError = error as? ErrorResponseBody
                if responseError?.isSuccess() ?? false {
                    self.expect.fulfill()
                }
                
                switch responseError {
                case .errorCode(let code):
                    if code == 1004 {
                        self.model?.refreshAccessToken()
                            .subscribe(onSuccess: { result in
                                self.expect.fulfill()
                            })
                            .disposed(by: self.disposeBag)
                    } else {
                        XCTFail("HTTPError. \(responseError?.getErrorMessage() ?? LoginRequestHTTPModel.defaultErrorMessage)")
                    }
                default:
                    XCTFail("HTTPError. \(responseError?.getErrorMessage() ?? LoginRequestHTTPModel.defaultErrorMessage)")
                }
            })
            .disposed(by: disposeBag)
        
        wait(for: [expect], timeout: 5.0)
    }
    
    func test_refreshAccessToken() throws {
        model?.refreshAccessToken()
            .subscribe(onSuccess: { [weak self] response in
                self?.expect.fulfill()
            }, onFailure: { error in
                let responseError = error as? ErrorResponseBody
                if responseError?.isSuccess(successCode: 1004) ?? false { // request created but no cookie.
                    self.expect.fulfill()
                } else {
                    XCTFail("HTTPError. \(responseError?.localizedDescription ?? LoginRequestHTTPModel.defaultErrorMessage)")
                }
            })
            .disposed(by: disposeBag)
        
        wait(for: [expect], timeout: 3.0)
    }
}

private extension ErrorResponseBody {
    func isSuccess(successCode: Int = 1001) -> Bool {
        switch self {
        case .errorCode(let code):
            return (code == successCode)
        default:
            return false
        }
    }
}
