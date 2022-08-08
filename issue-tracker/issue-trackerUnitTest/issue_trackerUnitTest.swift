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
        let expect = XCTestExpectation()
        
        for sentence in sentences {
            validation.testValidate(category: .email, sentence) { result in
                print(result)
                
                if sentence == sentences.last {
                    expect.fulfill()
                }
            }
        }
        
        wait(for: [expect], timeout: 5.0)
    }
}
