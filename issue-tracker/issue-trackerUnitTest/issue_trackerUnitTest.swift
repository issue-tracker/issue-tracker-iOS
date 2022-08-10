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
        let decoder = JSONDecoder()
        expect.expectedFulfillmentCount = 2
        
        validation.nextHandler = { data in
            if (try? decoder.decode(Bool.self, from: data)) != nil {
                expect.fulfill()
            }
        }
        
        validation.doTest()
        validation.doTest()
        
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
