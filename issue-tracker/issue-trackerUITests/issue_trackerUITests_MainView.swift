//
//  issue_trackerUITests_MainView.swift
//  issue-trackerUITests
//
//  Created by 백상휘 on 2022/09/02.
//

import XCTest

class issue_trackerUITests_MainView: CommonTestCase {
    
    private let textFieldIds = ["idArea", "passwordArea", "passwordConfirmedArea", "emailArea", "nicknameArea"]
    private let buttonIds = ["가입하기"]
    
    override func prepareEachTest() {
        app.descendants(matching: .button)["회원가입"].tap()
    }
    
    override func tearDownEachTest() {
        app.navigationBars.firstMatch.buttons.firstMatch.tap()
    }
    
    override func doVisibleTest() {
        super.doVisibleTest()
        XCTAssertNotNil(app.children(matching: .window).firstMatch.exists)
        
        for (index, result) in app.isViewExists(ids: textFieldIds).enumerated() {
            XCTAssertTrue(result, "[Error] \(textFieldIds[index]) not exsits")
        }
        
        for (index, result) in app.isButtonExists(ids: buttonIds).enumerated() {
            XCTAssertTrue(result, "[Error] \(buttonIds[index]) not exsits")
        }
        
        tearDownEachTest()
    }
    
    override func doFunctionTest() {
        super.doFunctionTest()
        tearDownEachTest()
    }
}
