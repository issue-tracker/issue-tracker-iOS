//
//  XCUIApplication+Extension.swift
//  issue-trackerUITests
//
//  Created by 백상휘 on 2022/09/03.
//

import XCTest

extension XCUIApplication {
    func isButtonExists(id: String) -> Bool {
        self.buttons[id].firstMatch.exists
    }
    
    func isButtonExists(ids: [String]) -> [Bool] {
        ids.map { self.buttons[$0].firstMatch.exists }
    }
    
    func isTextFieldExsits(id: String) -> Bool {
        self.descendants(matching: .textField).firstMatch.exists
    }
    
    func isTextFieldExsits(ids: [String]) -> [Bool] {
        ids.map { _ in self.descendants(matching: .textField).firstMatch.exists }
    }
}

extension XCUIApplication {
    func getViewUsing(id: String) -> XCUIElement {
        self.otherElements[id].firstMatch
    }
    
    func getViewUsing(ids: String...) -> [XCUIElement] {
        var result = [XCUIElement]()
        
        for id in ids {
            let element = self.otherElements[id].firstMatch
            if element.exists {
                result.append(element)
            }
        }
        
        return result
    }
    
    func isViewExists(ids: [String]) -> [Bool] {
        ids.map { self.otherElements[$0].exists }
    }
}
