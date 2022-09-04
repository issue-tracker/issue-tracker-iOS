//
//  CommonTestCase.swift
//  issue-trackerUITests
//
//  Created by 백상휘 on 2022/09/03.
//

import XCTest

class CommonTestCase: XCTestCase, CommonUITest {
    var app: XCUIApplication!
    
    init(app: XCUIApplication) {
        super.init(invocation: nil)
        self.app = app
    }
    
    func prepareEachTest() { }
    
    func tearDownEachTest() { }
    
    func doVisibleTest() {
        prepareEachTest()
    }
    
    func doFunctionTest() {
        prepareEachTest()
    }
}
