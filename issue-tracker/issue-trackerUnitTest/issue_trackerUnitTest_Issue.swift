//
//  issue_trackerUnitTest_Issue.swift
//  issue-trackerUnitTests
//
//  Created by 백상휘 on 2022/08/30.
//

import XCTest

class issue_trackerUnitTest_Issue: XCTestCase {
    var expectation: XCTestExpectation!
    
    var issueModel: MainViewSingleRequestModel<AllIssueEntity>?
    var labelModel: MainViewRequestModel<LabelListEntity>?
    var milestoneModel: MainViewSingleRequestModel<AllMilestoneEntity>?

    override func setUp() {
        URLProtocol.registerClass(MainViewProtocol.self)
        expectation = XCTestExpectation()
        
        issueModel = MainViewSingleRequestModel<AllIssueEntity>(URL(string: Bundle.main.path(forResource: "Issues", ofType: "json") ?? ""))
        labelModel = MainViewRequestModel<LabelListEntity>(URL(string: Bundle.main.path(forResource: "Labels", ofType: "json") ?? ""))
        milestoneModel = MainViewSingleRequestModel<AllMilestoneEntity>(URL(string: Bundle.main.path(forResource: "Milestones", ofType: "json") ?? ""))
    }
    override func tearDown() {
        URLProtocol.unregisterClass(MainViewProtocol.self)
    }

    func testIssueList() throws {
        issueModel?.builder.setURLQuery(["page" : "0"])
        issueModel?.requestIssueList(requestHandler: { entity in
            if entity != nil {
                self.expectation.fulfill()
            }
        })
        
        wait(for: [expectation], timeout: (1.5))
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
