//
//  issue_trackerUnitTest_Issue.swift
//  issue-trackerUnitTests
//
//  Created by 백상휘 on 2022/08/30.
//

import XCTest

class issue_trackerUnitTest_Issue: XCTestCase {
    
    var issueModel: IssueListRequestModel!
    var issueJSONFileURL: URL!
    let issueExpectation = XCTestExpectation()

    override func setUp() {
        URLProtocol.registerClass(IssueListProtocol.self)
        
        guard let issueURL = IssueListProtocol.url else {
            XCTFail("[Error] \(#file) get URL failed.")
            return
        }
        
        issueJSONFileURL = issueURL
        issueModel = IssueListRequestModel(issueURL)
    }
    override func tearDown() {
        URLProtocol.unregisterClass(IssueListProtocol.self)
    }

    func testIssueList() throws {
        
        issueExpectation.expectedFulfillmentCount = 3
        issueModel.requestIssueList(0) { _, list in
            self.issueExpectation.fulfill()
        }
        issueModel.requestIssueList(1) { _, list in
            self.issueExpectation.fulfill()
        }
        issueModel.reloadIssueList { list in
            self.issueExpectation.fulfill()
        }
        
        wait(for: [issueExpectation], timeout: (Double(issueExpectation.expectedFulfillmentCount) * 1.5))
    }
    
//    func testIssueEdit() throws {
//
//    }
//
//    func testIssueDelete() throws {
//
//    }
//
//    func testLabelList() throws {
//
//    }
//
//    func testLabelEdit() throws {
//
//    }
//
//    func testLabelDelete() throws {
//
//    }
//
//    func testMilestoneList() throws {
//
//    }
//
//    func testMilestoneEdit() throws {
//
//    }
//
//    func testMilestoneDelete() throws {
//
//    }
//
//    func testPerformanceExample() throws {
//        self.measure {
//        }
//    }

}
