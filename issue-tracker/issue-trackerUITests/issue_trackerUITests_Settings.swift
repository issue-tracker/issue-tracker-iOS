//
//  issue_trackerUITests_Settings.swift
//  issue-trackerUITests
//
//  Created by 백상휘 on 2022/10/17.
//

import XCTest

class issue_trackerUITests_Settings: CommonTestCase {
    
    override func doVisibleTest() {
        app.tabBars.buttons.element(boundBy: 2).tap()
        
        func selectCells(at index: Int) {
            var index = index
            let backButton = app.navigationBars.buttons.firstMatch
            let cell = app.tables.cells.element(boundBy: index)
            
            if cell.exists && backButton.exists == false {
                cell.tap()
            }
            
            if backButton.exists {
                backButton.tap()
                index += 1
            }
            
            if app.tables.cells.count > index {
                for i in index..<app.tables.cells.count {
                    selectCells(at: i)
                }
            } else {
                app.buttons.matching(identifier: "BackButton").firstMatch.tap()
            }
        }
        
        selectCells(at: 0)
        selectCells(at: 1)
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
