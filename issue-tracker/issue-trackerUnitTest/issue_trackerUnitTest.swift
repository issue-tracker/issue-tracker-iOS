//
//  issue_trackerUnitTest.swift
//  issue-trackerUnitTest
//
//  Created by 백상휘 on 2022/08/08.
//

import XCTest

class issue_trackerUnitTest: XCTestCase {
    
    func testRequest() throws {
        let validation = LoginValidationRequest()
        let sentences = ["aaaa", "eaa", "12345","a", "aaa"]
        let simpleTestExpectation = XCTestExpectation()
        let timerTestExpectation = XCTestExpectation()
        
        for sentence in sentences {
            validation.testValidate(category: .email, sentence) { result in
                if sentence == sentences.last {
                    simpleTestExpectation.fulfill()
                }
            }
        }
        
        validation.randomInputTest(sentences) { result in
            timerTestExpectation.fulfill()
        }
        
        wait(for: [simpleTestExpectation, timerTestExpectation], timeout: 5.0)
    }
}
