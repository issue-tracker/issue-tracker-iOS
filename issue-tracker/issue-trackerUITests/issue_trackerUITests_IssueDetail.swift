//
//  issue_trackerUITests_IssueDetail.swift
//  issue-trackerUITests
//
//  Created by 백상휘 on 2022/09/14.
//

import XCTest

class issue_trackerUITests_IssueDetail: CommonTestCase {
    override func doVisibleTest() {
        
        let listControl = app.descendants(matching: .segmentedControl)["listControl"]
        XCTAssertTrue(listControl.waitForExistence(timeout: 4.0), "listControl not shown.") 
        
        listControl
            .children(matching: .button)
            .firstMatch
            .tap()
        
        app.descendants(matching: .scrollView)["listScrollView"]
            .descendants(matching: .table)
            .cells
            .firstMatch
            .tap()
        
        takeScreenshot(named: "test")
//        let screenshot = XCTAttachment(screenshot: app.screenshot())
//        screenshot.lifetime = .keepAlways
//        add(screenshot)
    }
}
