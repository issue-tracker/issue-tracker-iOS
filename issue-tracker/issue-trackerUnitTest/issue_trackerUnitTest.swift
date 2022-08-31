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
    var expect: XCTestExpectation!
    var model: RequestHTTPModel?
    var timerModel: RequestHTTPTimerModel?
    var url: URL? = URL.membersApiURL
    
    override func setUp() {
        expect = XCTestExpectation()
        
        if let url = url {
            model = RequestHTTPModel(url)
            timerModel = RequestHTTPTimerModel(timerInterval: 2, url)
        }
    }
    
    override func tearDown() { }
    
    func testSingleRequestModel() throws {
        expect.expectedFulfillmentCount = 2
        
        guard let model = model else {
            XCTFail("URL membersApiURL not defined Error.")
            return
        }
        
        model.request(pathArray: ["nickname","testSingleRequestModel","exists"]) { result, _ in
            switch result {
            case .success(_):
                self.expect.fulfill()
            case .failure(let error):
                XCTFail("Request Failed \(error)")
            }
        }
        model.requestObservable(pathArray: ["nickname","test","exists"])
            .subscribe { result in
                if result.element != nil {
                    self.expect.fulfill()
                }
            }
            .disposed(by: bag)
        
        wait(for: [expect], timeout: 5.0)
    }
    
    func testSingleRequestTimerModel() throws {
        expect.expectedFulfillmentCount = 2
        
        guard let model = timerModel else {
            XCTFail("URL membersApiURL not defined Error.")
            return
        }
        
        model.requestAsTimer(pathArray: ["nickname","test","exists"]) { result, _ in
            switch result {
            case .success(_):
                self.expect.fulfill()
            case .failure(_):
                XCTFail("Request Failed")
            }
        }
        model.requestAsDelayedObservable(pathArray: ["nickname","test","exists"])
            .subscribe { result in
                if result.element != nil {
                    self.expect.fulfill()
                }
            }
            .disposed(by: bag)
        
        wait(for: [expect], timeout: 9.0)
    }
}
