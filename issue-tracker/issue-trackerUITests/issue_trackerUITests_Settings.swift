//
//  issue_trackerUITests_Settings.swift
//  issue-trackerUITests
//
//  Created by 백상휘 on 2022/10/17.
//

import XCTest

class issue_trackerUITests_Settings: CommonTestCase {
    
    override func doFunctionTest() {
        app.tabBars.buttons.element(boundBy: 2).tap()
        
        app.tables.cells.element(boundBy: 2).tap()
        app.collectionViews.cells.element(boundBy: 0).descendants(matching: .switch).element.tap()
        app.navigationBars.buttons.firstMatch.tap()
        
        app.tables.cells.element(boundBy: 2).tap()
        app.collectionViews.cells.element(boundBy: 1).descendants(matching: .switch).element.tap()
        app.navigationBars.buttons.firstMatch.tap()
    }
    
    override func doVisibleTest() {
        app.tables.cells.element(boundBy: 2).tap()
        XCTAssertTrue(app.collectionViews.cells.element(boundBy: 1).descendants(matching: .switch).element.isOn)
    }
}

private extension XCUIElement {
    var isOn: Bool {
        if let isOn = self.value as? String {
            return isOn == "1"
        }
        
        return (self.value as? Bool) ?? false
    }
}
