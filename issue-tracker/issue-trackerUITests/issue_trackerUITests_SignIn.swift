//
//  issue_trackerUITests_SignIn.swift
//  issue-trackerUITests
//
//  Created by 백상휘 on 2022/09/06.
//

import XCTest

class issue_trackerUITests_SignIn: CommonTestCase {
    
    override func prepareEachTest() {
        issue_trackerUITests_Login(app: app).logOutIfAlreadyLogin()
        
        let button = app.descendants(matching: .button)["회원가입"]
        if button.waitForExistence(timeout: 1.5) {
            button.tap()
        }
    }
    
    override func tearDownEachTest() {
        sleep(2)
        app.navigationBars.firstMatch.buttons.firstMatch.tap()
    }
    
    override func doVisibleTest() {
        self.prepareEachTest()
        
        XCTAssertTrue(app.textFields.element(boundBy: 0).exists)
        XCTAssertTrue(app.textFields.element(boundBy: 1).exists)
        XCTAssertTrue(app.textFields.element(boundBy: 2).exists)
        
        XCTAssertTrue(app.secureTextFields.element(boundBy: 0).exists)
        XCTAssertTrue(app.secureTextFields.element(boundBy: 1).exists)
        
        XCTAssertTrue(app.buttons.element.exists)
    }
    
    override func doFunctionTest() {
        
        self.prepareEachTest()
        
        let idField = app.textFields.element(boundBy: 0)
        let passwordField = app.secureTextFields.element(boundBy: 0)
        let passwordConfirmedField = app.secureTextFields.element(boundBy: 1)
        let emailField = app.textFields.element(boundBy: 1)
        let nicknameField = app.textFields.element(boundBy: 2)
        
        idField.tap()
        idField.typeText("testios")
        
        passwordField.tap()
        passwordField.typeText("12341234")
        
        passwordConfirmedField.tap()
        passwordConfirmedField.typeText("12341234")
        
        app.scrollViews.element.swipeUp()
        
        guard emailField.waitForExistence(timeout: 2.0) else {
            XCTFail("[Error] emailField not exists")
            return
        }
        emailField.tap()
        emailField.typeText("testios@gmail.com")
        
        guard nicknameField.waitForExistence(timeout: 2.0) else {
            XCTFail("[Error] nicknameField not exists")
            return
        }
        nicknameField.tap()
        nicknameField.typeText("테스트아이오에스")
        
        app.descendants(matching: .button)["가입하기"].tap()
    }
}
