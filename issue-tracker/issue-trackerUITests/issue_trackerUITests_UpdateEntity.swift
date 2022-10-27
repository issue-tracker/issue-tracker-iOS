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
        
        guard
            app.segmentedControls.element.exists,
            app.textFields.matching(identifier: "issueUpdateTitle").firstMatch.exists,
            app.textViews.matching(identifier: "issueUpdateContents").firstMatch.exists
        else {
            XCTFail("Test Failed. View doesn't exists.")
            return
        }
        
        sleep(5)
    }
}

