//
//  issue_trackerUnitTest_Issue.swift
//  issue-trackerUnitTests
//
//  Created by 백상휘 on 2022/08/30.
//

import XCTest

class issue_trackerUnitTest_Issue: XCTestCase {
    var expectation: XCTestExpectation!
    
    var issueModel: MainViewRequestModel<IssueListEntity>?
    var labelModel: MainViewRequestModel<LabelListEntity>?
    var milestoneModel: MainViewSingleRequestModel<AllMilestoneEntity>?

    override func setUp() {
        URLProtocol.registerClass(MainViewProtocol.self)
        expectation = XCTestExpectation()
        
        issueModel = MainViewRequestModel<IssueListEntity>(URL(string: Bundle.main.path(forResource: "Issues", ofType: "json") ?? ""))
        labelModel = MainViewRequestModel<LabelListEntity>(URL(string: Bundle.main.path(forResource: "Labels", ofType: "json") ?? ""))
        milestoneModel = MainViewSingleRequestModel<AllMilestoneEntity>(URL(string: Bundle.main.path(forResource: "Milestones", ofType: "json") ?? ""))
    }
    override func tearDown() {
        URLProtocol.unregisterClass(MainViewProtocol.self)
    }

    func testIssueList() throws {
        expectation.expectedFulfillmentCount = 3
        
        issueModel?.requestIssueList(0) { _, list in
            self.expectation.fulfill()
        }
        issueModel?.requestIssueList(1) { _, list in
            self.expectation.fulfill()
        }
        issueModel?.reloadIssueList { _ in
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: (3 * 1.5))
    }
    
    func testLabelList() throws {
        expectation.expectedFulfillmentCount = 3
        
        labelModel?.requestIssueList(0) { _, list in
            self.expectation.fulfill()
        }
        labelModel?.requestIssueList(1) { _, list in
            self.expectation.fulfill()
        }
        labelModel?.reloadIssueList { list in
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: (3 * 1.5))
    }
    
    func testMilestoneList() throws {
        milestoneModel?.requestIssueList { list in
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.5)
    }
}
