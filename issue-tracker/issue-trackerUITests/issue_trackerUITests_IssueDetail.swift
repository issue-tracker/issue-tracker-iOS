//
//  issue_trackerUITests_IssueDetail.swift
//  issue-trackerUITests
//
//  Created by 백상휘 on 2022/09/14.
//

import XCTest

class issue_trackerUITests_IssueDetail: CommonTestCase {
    override func doVisibleTest() {
    }
    
    override func doFunctionTest() {
        
        if app.segmentedControls.firstMatch.exists == false {
            issue_trackerUITests_Login(app: app).doFunctionTest()
            
            guard app.segmentedControls.firstMatch.exists else {
                XCTFail("[Error] Login Test Error")
                return
            }
        }
        
        if app.segmentedControls.element.waitForExistence(timeout: 2.0) {
            
            app.descendants(matching: .scrollView)["listScrollView"]
                .descendants(matching: .table)
                .cells
                .firstMatch
                .tap()
        }
    }
}
