//
//  issue_trackerUnitTest.swift
//  issue-trackerUnitTest
//
//  Created by 백상휘 on 2022/08/08.
//

import XCTest
import RxSwift

class issue_trackerUnitTest: XCTestCase {
    
    var disposeBag = DisposeBag()
    
    func releaseDisposeBag() {
        disposeBag = DisposeBag()
    }
    
    override class func setUp() {
        super.setUp()
        
    }
    
    func testRequest() throws {
        let validation = LoginValidationRequest()
        let expect = XCTestExpectation()
        expect.expectedFulfillmentCount = 2
        
        validation.testValidate(category: .email, "asdfas") { result in
            expect.fulfill()
        }
        
        validation.testValidate(category: .email, "asiodf")
            .subscribe(onNext: { result in
                print("result is \(result.count)")
            }, onError: { error in
                print(error)
            }, onCompleted: {
                expect.fulfill()
            }, onDisposed: {
                print("disposed")
            })
            .disposed(by: disposeBag)
        
        wait(for: [expect], timeout: 5.0)
    }
    
    func singleRequestTest(completionHandler: @escaping () -> Void) {
        print("[Unit Test] Start")
        completionHandler()
        print("[Unit Test] Ends")
        releaseDisposeBag()
    }
    
    /// - Parameter completionHandler: 전달하는 Integer 파라미터는 실행한 순서
    func multipleRequestOneResponseTest(requestCount: Int = 5, completionHandler: @escaping (Int) -> Void) {
        for i in 0..<requestCount {
            print("[Unit Test] \(i)# Start")
            completionHandler(i+1)
            print("[Unit Test] \(i)# Ends")
        }
        
        releaseDisposeBag()
    }
}
