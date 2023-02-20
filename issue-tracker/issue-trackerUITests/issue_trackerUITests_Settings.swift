//
//  issue_trackerUITests_Settings.swift
//  issue-trackerUITests
//
//  Created by 백상휘 on 2022/10/17.
//

import XCTest

typealias Element = (index: Int, cell: XCUIElement)

class issue_trackerUITests_Settings: CommonTestCase {
    
    class CustomStack {
        private var elements: [Element] = []
        var count: Int {
            elements.count
        }
        
        @discardableResult
        func dequeue() -> Element? {
            guard elements.isEmpty == false else {
                return nil
            }
            
            return elements.removeLast()
        }
        
        func enqueue(_ element: Element) {
            elements.append(element)
        }
        
        func contains(_ element: Element) -> Bool {
            elements.firstIndex(where: { $0.cell == element.cell }) != nil
        }
        
        func addCellsInQueue(cells: XCUIElementQuery,through count: Int, continueHandler: ((Int)->Bool)? = nil) {
            for i in (0..<count).reversed() {
                if let handler = continueHandler, handler(i) == false {
                    continue
                }
                
                let element = cells.element(boundBy: i)
                self.enqueue((index: i, cell: element))
            }
        }
    }
    
    override func doVisibleTest() {
        app.tabBars.buttons.element(boundBy: 2).tap()
        
        let queue = CustomStack()
        
        var cellCount: Int {
            app.tables.cells.count
        }
        
        func selectCell(_ element: Element) {
            
            element.cell.tap()
            
            var backButton = app.navigationBars.buttons.firstMatch
            guard backButton.exists == false else {
                backButton.tap()
                
                backButton = app.buttons.matching(identifier: "BackButton").firstMatch
                if backButton.exists, element.index == app.tables.cells.count-1 {
                    backButton.tap()
                }
                
                if let element = queue.dequeue() {
                    selectCell(element)
                }
                return
            }
            
            queue.addCellsInQueue(cells: app.tables.cells, through: cellCount)
            
            if let element = queue.dequeue() {
                selectCell(element)
            }
        }
        
        queue.addCellsInQueue(cells: app.tables.cells, through: app.tables.cells.count)
        
        if let element = queue.dequeue() {
            selectCell(element)
        }
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
