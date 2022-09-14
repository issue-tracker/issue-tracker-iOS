//
//  issue_trackerUITests.swift
//  issue-trackerUITests
//
//  Created by 백상휘 on 2022/08/08.
//

import XCTest

class issue_trackerUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app.terminate()
    }
    
    func test_Login() throws {
        issue_trackerUITests_Login(app: app).doVisibleTest()
    }
    
    func test_SignIn() throws {
        issue_trackerUITests_SignIn(app: app).doVisibleTest()
        issue_trackerUITests_SignIn(app: app).doFunctionTest()
    }
    
    func test_MainView() throws {
        issue_trackerUITests_MainView(app: app).doFunctionTest()
        issue_trackerUITests_MainView(app: app).doVisibleTest()
    }
    
    func test_IssueDetailView() throws {
        issue_trackerUITests_IssueDetail(app: app).doVisibleTest()
    }
}
