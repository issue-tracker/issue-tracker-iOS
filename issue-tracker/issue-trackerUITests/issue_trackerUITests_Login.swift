//
//  issue_trackerUITests_Login.swift
//  issue-trackerUITests
//
//  Created by 백상휘 on 2022/09/02.
//

import XCTest

class issue_trackerUITests_Login: CommonTestCase {
    
    let textFieldIds = ["아이디", "패스워드"]
    let buttonIds = ["아이디로 로그인", "비밀번호 재설정", "회원가입", "간편회원가입"]
    
    override func prepareEachTest() {
        logOutIfAlreadyLogin()
    }
    
    override func doVisibleTest() {
        prepareEachTest()
        
        XCTAssertNotNil(app.children(matching: .window).firstMatch.exists)
        
        for (index, result) in app.isTextFieldExsits(ids: textFieldIds).enumerated() {
            XCTAssertTrue(result, "[Error] \(textFieldIds[index]) not exsits")
        }
        
        for (index, result) in app.isButtonExists(ids: buttonIds).enumerated() {
            XCTAssertTrue(result, "[Error] \(buttonIds[index]) not exsits")
        }
        
        tearDownEachTest()
    }
    
    override func doFunctionTest() {
        prepareEachTest()
        
        let idTextField = app.descendants(matching: .textField).matching(identifier: textFieldIds[0]).firstMatch
        idTextField.tap()
        idTextField.typeText("testios")
        
        let passwordTextField = app.descendants(matching: .secureTextField).matching(identifier: textFieldIds[1]).firstMatch
        passwordTextField.tap()
        passwordTextField.typeText("12341234")
        
        let loginButton = app.descendants(matching: .button)[buttonIds.first!]
        loginButton.tap()
    }
    
    func logOutIfAlreadyLogin() {
        if app.tabBars.firstMatch.exists {
            logOut()
        }
    }
    
    func logOut() {
        let tabBarButtons = app.tabBars.firstMatch.descendants(matching: .button)
        
        if tabBarButtons["Settings"].exists, tabBarButtons["Settings"].isSelected {
            app.tabBars.firstMatch.descendants(matching: .button)["List"].tap()
        }
        
        let profileButton = app.otherElements["profileView"].firstMatch
        guard profileButton.exists else {
            XCTFail("[Warning] This is not MainView."); return
        }
        
        profileButton.press(forDuration: 2.0)
        
        app.descendants(matching: .collectionView).cells.firstMatch.tap()
    }
}
