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
        ids.map {
            self.buttons[$0].firstMatch.exists
        }
    }
    
    func isTextFieldExsits(id: String) -> Bool {
        let query = self.descendants(matching: .textField)
        return query[id].firstMatch.exists
    }
    
    func isTextFieldExsits(ids: [String]) -> [Bool] {
        let query = self.descendants(matching: .textField)
        return ids.map {
            query[$0].firstMatch.exists
        }
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
    
    func isViewExists(id: String) -> Bool {
        self.getViewUsing(id: id).exists
    }
    
    func isViewExists(ids: String...) -> Bool {
        for id in ids {
            if self.getViewUsing(id: id).exists == false {
                return false
            }
        }
        return true
    }
    
    func isViewExists(ids: [String]) -> [Bool] {
        ids.map {
            self.otherElements[$0].exists
        }
    }
}
