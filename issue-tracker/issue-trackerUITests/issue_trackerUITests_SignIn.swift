//
//  issue_trackerUITests_SignIn.swift
//  issue-trackerUITests
//
//  Created by 백상휘 on 2022/09/06.
//

import XCTest

class issue_trackerUITests_SignIn: CommonTestCase {
    private let textFieldIds = ["idArea", "passwordArea", "passwordConfirmedArea", "emailArea", "nicknameArea"]
    private let buttonIds = ["가입하기"]
    
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
        
        XCTAssertNotNil(app.children(matching: .window).firstMatch.exists)
        
        for (index, result) in app.isViewExists(ids: textFieldIds).enumerated() {
            XCTAssertTrue(result, "[Error] \(textFieldIds[index]) not exsits")
        }
        
        for (index, result) in app.isButtonExists(ids: buttonIds).enumerated() {
            XCTAssertTrue(result, "[Error] \(buttonIds[index]) not exsits")
        }
    }
    
    override func doFunctionTest() {
        
        self.prepareEachTest()
        
        func getSubTextField(_ viewId: String, _ id: String) -> XCUIElement {
            if app.getViewUsing(id: viewId).textFields[id].exists {
                return app.getViewUsing(id: viewId).textFields[id]
            } else {
                return app.getViewUsing(id: viewId).secureTextFields[id]
            }
        }
        
        let idField = getSubTextField(textFieldIds[0], "아이디")
        let passwordField = getSubTextField(textFieldIds[1], "비밀번호")
        let passwordConfirmedField = getSubTextField(textFieldIds[2], "비밀번호 확인")
        let emailField = getSubTextField(textFieldIds[3], "이메일")
        let nicknameField = getSubTextField(textFieldIds[4], "닉네임")
        
        idField.tap()
        idField.typeText("testios")
        
        let isIdNotExists = app.otherElements["idArea"].staticTexts["이상이 발견되지 않았습니다."].waitForExistence(timeout: 7.0)
        // isIdNotExists 하지 않다 라는 것은 아이디가 이미 존재하거나, 네트워크 연결 실패이므로 더 이상 테스트 할 이유가 없음.
        if isIdNotExists == false {
            return
        }
        
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
        
        XCTAssertTrue(app.alerts.element.waitForExistence(timeout: 4.0))
        
        app.alerts.buttons.element.tap()
    }
}
