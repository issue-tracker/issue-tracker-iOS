//
//  issue_trackerUITests_IssueDetail.swift
//  issue-trackerUITests
//
//  Created by 백상휘 on 2022/09/14.
//

import XCTest

class issue_trackerUITests_IssueDetail: CommonTestCase {
    override func doVisibleTest() { }
    override func doFunctionTest() {
        
        let idField = app.descendants(matching: .textField)["아이디"]
        let passwordField = app.descendants(matching: .secureTextField)["패스워드"]
        
        idField.tap()
        idField.typeText("iosTestUser")
        passwordField.tap()
        passwordField.typeText("12341234")
        app.descendants(matching: .button)["아이디로 로그인"].tap()
        
        XCTAssertTrue(app.segmentedControls.element.waitForExistence(timeout: 4.0), "listControl not shown.")
        app.segmentedControls.buttons.element(boundBy: 0).tap()
        app.segmentedControls.buttons.element(boundBy: 1).tap()
        app.segmentedControls.buttons.element(boundBy: 2).tap()
        app.segmentedControls.buttons.element(boundBy: 0).tap()
        
        app.descendants(matching: .scrollView)["listScrollView"]
            .descendants(matching: .table)
            .cells
            .firstMatch
            .tap()
    }
}
