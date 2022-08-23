//
//  issue_trackerUnitTest.swift
//  issue-trackerUnitTest
//
//  Created by 백상휘 on 2022/08/08.
//

import XCTest
import RxSwift

class issue_trackerUnitTest: XCTestCase {
    
    var bag = DisposeBag()
    
    func testLogin() throws {
        let validation = LoginValidationRequest()
        let expect = XCTestExpectation()
        let decoder = JSONDecoder()
        expect.expectedFulfillmentCount = 2
        
        validation.nextHandler = { data in
            if (try? decoder.decode(Bool.self, from: data)) != nil {
                expect.fulfill()
            }
        }
        
        multipleRequestOneResponseTest(requestCount: 2, validation)
        
        wait(for: [expect], timeout: 5.0)
    }
    
    func testSingleRequestModel() throws {
        let expect = XCTestExpectation()
        expect.expectedFulfillmentCount = 2
        
        guard let url = URL.membersApiURL else {
            XCTFail("URL membersApiURL not defined Error.")
            return
        }
        
        let model = RequestHTTPModel(url)
        model.request(pathArray: ["nickname","test","exists"]) { result, _ in
            switch result {
            case .success(_):
                expect.fulfill()
            case .failure(_):
                XCTFail("Request Failed")
            }
        }
        model.requestObservable(pathArray: ["nickname","test","exists"])
            .subscribe { result in
                if result.element != nil {
                    expect.fulfill()
                }
            }
            .disposed(by: bag)
        
        wait(for: [expect], timeout: 5.0)
    }
    
    func testSingleRequestTimerModel() throws {
        let expect = XCTestExpectation()
        expect.expectedFulfillmentCount = 2
        
        guard let url = URL.membersApiURL else {
            XCTFail("URL membersApiURL not defined Error.")
            return
        }
        
        let model = RequestHTTPTimerModel(timerInterval: 2, url)
        model.requestAsTimer(pathArray: ["nickname","test","exists"]) { result, _ in
            switch result {
            case .success(_):
                expect.fulfill()
            case .failure(_):
                XCTFail("Request Failed")
            }
        }
        model.requestAsDelayedObservable(pathArray: ["nickname","test","exists"])
            .subscribe { result in
                if result.element != nil {
                    expect.fulfill()
                }
            }
            .disposed(by: bag)
        
        wait(for: [expect], timeout: 9.0)
    }
    
    func testIssueList() throws {
        let issueListModel = URL.apiURL == nil ? nil : IssueListRequestModel(URL.apiURL!)
        let expect = XCTestExpectation()
        let decoder = JSONDecoder()
        expect.expectedFulfillmentCount = 3
        
        issueListModel?.nextHandler = { data in
            if (try? decoder.decode([IssueListEntity].self, from: data)) != nil {
                expect.fulfill()
            }
        }
        
        issueListModel?.doTest(nil)
        issueListModel?.doTest(nil)
        issueListModel?.doTest(nil)
        
        wait(for: [expect], timeout: 5.0)
    }
    
    func singleRequestTest(_ testable: Testable) {
        testable.doTest(nil)
    }
    
    /// - Parameter completionHandler: 전달하는 Integer 파라미터는 실행한 순서
    func multipleRequestOneResponseTest(requestCount: Int = 5, _ testable: Testable) {
        for _ in 0..<requestCount {
            testable.doTest(nil)
        }
    }
}
