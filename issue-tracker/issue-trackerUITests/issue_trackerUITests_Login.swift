//
//  issue_trackerUITests_Login.swift
//  issue-trackerUITests
//
//  Created by 백상휘 on 2022/09/02.
//

import XCTest

class issue_trackerUITests_Login: CommonTestCase {
    override func doVisibleTest() {
        XCTAssertNotNil(app.children(matching: .window).firstMatch.exists)
        
        let textFieldIds = ["아이디", "패스워드"]
        for (index, result) in app.isTextFieldExsits(ids: textFieldIds).enumerated() {
            XCTAssertTrue(result, "[Error] \(textFieldIds[index]) not exsits")
        }
        
        let buttonIds = ["아이디로 로그인", "비밀번호 재설정", "회원가입", "간편회원가입"]
        for (index, result) in app.isButtonExists(ids: buttonIds).enumerated() {
            XCTAssertTrue(result, "[Error] \(buttonIds[index]) not exsits")
        }
    }
    
    override func doFunctionTest() {
        
    }
}
