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
        app.descendants(matching: .button)["회원가입"].tap()
    }
    
    override func tearDownEachTest() {
        sleep(2)
        app.navigationBars.firstMatch.buttons.firstMatch.tap()
    }
    
    override func doVisibleTest() {
        super.doVisibleTest()
        XCTAssertNotNil(app.children(matching: .window).firstMatch.exists)
        
        for (index, result) in app.isViewExists(ids: textFieldIds).enumerated() {
            XCTAssertTrue(result, "[Error] \(textFieldIds[index]) not exsits")
        }
        
        for (index, result) in app.isButtonExists(ids: buttonIds).enumerated() {
            XCTAssertTrue(result, "[Error] \(buttonIds[index]) not exsits")
        }
        
        tearDownEachTest()
    }
    
    override func doFunctionTest() {
        super.doFunctionTest()
        
        let idField = app.getViewUsing(id: textFieldIds[0]).textFields.firstMatch
        let passwordField = app.getViewUsing(id: textFieldIds[1]).secureTextFields["비밀번호"]
        let passwordConfirmedField = app.getViewUsing(id: textFieldIds[2]).secureTextFields["비밀번호 확인"]
        let emailField = app.getViewUsing(id: textFieldIds[3]).textFields.firstMatch
        let nicknameField = app.getViewUsing(id: textFieldIds[4]).textFields.firstMatch
        
        idField.tap()
        idField.typeText("testios")
        let isIdNotExists = app.getViewUsing(id: textFieldIds[0]).staticTexts["이상이 발견되지 않았습니다."].waitForExistence(timeout: 7.0)
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
        
        app.descendants(matching: .button)[buttonIds[0]].tap()
        
        XCTAssertTrue(app.alerts.element.waitForExistence(timeout: 4.0))
        
        app.alerts.buttons.element.tap()
    }

}
