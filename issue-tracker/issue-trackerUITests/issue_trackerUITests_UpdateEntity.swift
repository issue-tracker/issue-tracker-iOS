//
//  issue_trackerUITests_UpdateEntity.swift
//  issue-trackerUITests
//
//  Created by 백상휘 on 2022/10/27.
//

import XCTest

class issue_trackerUITests_UpdateEntity: CommonTestCase {
    
    override func doFunctionTest() { }
    
    override func doVisibleTest() {
        guard app.tabBars.firstMatch.exists else {
            XCTFail("Test Failed. View doesn't exists.")
            return
        }
        
        app.tabBars.buttons.element(boundBy: 0).tap()
        app.buttons.matching(identifier: "issueUpdateEntry").firstMatch.tap()
        
        let titleTextField = app.textFields.matching(identifier: "issueUpdateTitle").firstMatch
        let contentsTextView = app.textViews.matching(identifier: "issueUpdateContents").firstMatch
        
        guard app.segmentedControls.element.exists, titleTextField.exists, contentsTextView.exists else {
            XCTFail("Test Failed. View doesn't exists.")
            return
        }
        
        let title = "iOS에서 테스트한 이슈 타이틀~"
        let contents = "iOS에서 테스트한 이슈 내용입니다. 내용내용내용내용 contentscontentscontentscontents"
        
        titleTextField.tap()
        titleTextField.typeText(title)
        
        contentsTextView.tap()
        contentsTextView.typeText(contents)
        
//        titleTextField.tap()
//        titleTextField.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: title.count))
        app.navigationBars.buttons.element(boundBy: 1).tap()
        
        sleep(5)
    }
}

