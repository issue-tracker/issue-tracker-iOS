//
//  issue_trackerUnitTest_SignIn.swift
//  issue-trackerUnitTests
//
//  Created by 백상휘 on 2022/11/22.
//

import XCTest
import RxSwift

final class issue_trackerUnitTest_SignIn: XCTestCase {
    
    private var disposeBag = DisposeBag()
    
    func test_SignInFormReactor_CheckInput() throws {
        let reactor = SignInFormReactor()
        let expectation = XCTestExpectation()
        let cases = SignInCases()
        
        expectation.expectedFulfillmentCount = cases.fullfillmentCount
        
        [reactor.pulse(\.id.$status), reactor.pulse(\.password.$status), reactor.pulse(\.password.$confirmStatus), reactor.pulse(\.email.$status), reactor.pulse(\.nickname.$status)].forEach { observable in
            observable
                .subscribe(onNext: {
                    if $0 == .fine { expectation.fulfill() }
                })
                .disposed(by: disposeBag)
        }
        
        for id in (cases.idTestFailableCases + cases.idTestFailableCases) {
            reactor.action.onNext(.checkIdTextField(id))
        }
        for (index, password) in cases.passwordSuccessCases.enumerated() {
            reactor.action.onNext(.checkPasswordTextField(password))
            reactor.action.onNext(.checkPasswordConfirmTextField(cases.passwordConfirmSuccessCases[index]))
        }
        for password in cases.passwordFailableCases {
            reactor.action.onNext(.checkPasswordTextField(password))
        }
        for email in (cases.emailSuccessCases + cases.emailFailableCases) {
            reactor.action.onNext(.checkEmailTextField(email))
        }
        for nickname in (cases.nicknameSuccessCases + cases.nicknameFailableCases) {
            reactor.action.onNext(.checkNicknameTextField(nickname))
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
