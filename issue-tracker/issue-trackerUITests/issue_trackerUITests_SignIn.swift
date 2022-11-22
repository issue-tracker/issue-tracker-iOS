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
        let cases = SignInCases()
        
        let idField = app.textFields.element(boundBy: 0)
        let passwordField = app.secureTextFields.element(boundBy: 0)
        let passwordConfirmedField = app.secureTextFields.element(boundBy: 1)
        let emailField = app.textFields.element(boundBy: 1)
        let nicknameField = app.textFields.element(boundBy: 2)
        
        // MARK: - Failable Tests
        
        idField.tap()
        
        for id in cases.idTestFailableCases {
            idField.clearAndEnterText(id)
        }
        
        for (index, password) in cases.passwordFailableCases.enumerated() {
            passwordField.tap()
            passwordField.clearAndEnterText(cases.passwordSuccessCases[index])
            passwordConfirmedField.tap()
            passwordConfirmedField.clearAndEnterText(password)
        }
        
        app.scrollViews.element.swipeUp()
        
        emailField.tap()
        for email in cases.emailFailableCases {
            emailField.clearAndEnterText(email)
        }
        
        nicknameField.tap()
        for nickname in cases.nicknameFailableCases {
            nicknameField.clearAndEnterText(nickname)
        }
        nicknameField.typeText("\n")
        
        // MARK: - Success Tests
        
        app.scrollViews.element.swipeDown()
        
        idField.tap()
        idField.clearAndEnterText("testios")

        passwordField.tap()
        passwordField.clearAndEnterText("12341234")

        passwordConfirmedField.tap()
        passwordConfirmedField.clearAndEnterText("12341234")
        
        app.scrollViews.element.swipeUp()
        
        emailField.tap()
        emailField.clearAndEnterText("testios@gmail.com")

        nicknameField.tap()
        nicknameField.clearAndEnterText("테스트아이오에스")
        
        app.descendants(matching: .button)["가입하기"].tap()
    }
}

extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(_ text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        self.tap()

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)

        self.typeText(deleteString)
        self.typeText(text)
    }
}
