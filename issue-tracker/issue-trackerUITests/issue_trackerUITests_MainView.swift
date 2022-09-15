//
//  issue_trackerUITests_MainView.swift
//  issue-trackerUITests
//
//  Created by 백상휘 on 2022/09/02.
//

import XCTest

class issue_trackerUITests_MainView: CommonTestCase {
    
    override func prepareEachTest() {
    }
    
    override func tearDownEachTest() {
        sleep(2)
        XCTAssertTrue(app.navigationBars.element.exists, "[Error] Screen Move Failed.") 
    }
    
    override func doVisibleTest() {
        super.doVisibleTest()
        
        tearDownEachTest()
    }
    
    override func doFunctionTest() {
        let idField = app.descendants(matching: .textField)["아이디"]
        let passwordField = app.descendants(matching: .secureTextField)["패스워드"]
        
        if idField.exists, passwordField.exists {
            idField.tap()
            idField.typeText("testios")
            passwordField.tap()
            passwordField.typeText("12341234")
            app.descendants(matching: .button)["아이디로 로그인"].tap()
            
            if app.alerts.element.waitForExistence(timeout: 2.0) {
                app.alerts.buttons.element.tap()
                XCTFail("[Error] Login Failed.")
                return
            }
        }
        
        XCTAssertTrue(app.segmentedControls.element.waitForExistence(timeout: 5.0))
        app.segmentedControls.buttons.element(boundBy: 1).tap()
        app.segmentedControls.buttons.element(boundBy: 2).tap()
        
        tearDownEachTest()
    }
}
