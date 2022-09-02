//
//  issue_trackerUITests.swift
//  issue-trackerUITests
//
//  Created by 백상휘 on 2022/08/08.
//

import XCTest

class issue_trackerUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        app.terminate()
    }
    
    func test_Login_VisibleView() throws {
        
        XCTAssertNotNil(app.children(matching: .window).firstMatch.exists)
        
        [
            "아이디": isTextFieldExsits("아이디"),
            "패스워드": isTextFieldExsits("패스워드"),
            "아이디로 로그인": isButtonExists("아이디로 로그인"),
            "비밀번호 재설정": isButtonExists("비밀번호 재설정"),
            "회원가입": isButtonExists("회원가입"),
            "간편회원가입": isButtonExists("간편회원가입")
        ].forEach {
            XCTAssertNotNil($0.value, "[Error] \($0.key) not exsits")
        }
    }
    
    func test_SignIn_VisibleView() throws {
        app.buttons["회원가입"].tap()
        
        [
            "아이디": app.isViewExists(id: "아이디") && isTextFieldExsits("아이디"),
            "비밀번호": app.isViewExists(id: "비밀번호") && isTextFieldExsits("비밀번호"),
            "비밀번호 확인": app.isViewExists(id: "비밀번호 확인") && isTextFieldExsits("비밀번호 확인"),
            "이메일": app.isViewExists(id: "이메일") && isTextFieldExsits("이메일"),
            "닉네임": app.isViewExists(id: "닉네임") && isTextFieldExsits("닉네임"),
            "가입하기": app.isViewExists(id: "가입하기") && isButtonExists("가입하기")
        ].forEach {
            XCTAssertNotNil($0.value, "[Error] \($0.key) not exsits")
        }
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension issue_trackerUITests {
    func isButtonExists(_ id: String) -> Bool {
        self.app.children(matching: .button).matching(.button, identifier: id).firstMatch.exists
    }
    func isTextFieldExsits(_ id: String) -> Bool {
        self.app.children(matching: .textField).matching(.button, identifier: id).firstMatch.exists
    }
}

extension XCUIApplication {
    func getViewUsing(id: String) -> XCUIElement {
        self.otherElements[id].firstMatch
    }
    func isViewExists(id: String) -> Bool {
        self.getViewUsing(id: id).exists
    }
}
