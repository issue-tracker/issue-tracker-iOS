//
//  issue_trackerUnitTest_Localizable.swift
//  issue-trackerUnitTests
//
//  Created by 백상휘 on 2022/12/13.
//

import XCTest

final class issue_trackerUnitTest_Localizable: XCTestCase {
  
  // TODO: 각 프로퍼티에 접근하는 새로운 방법이 필요. 각 프로퍼티에 직접 접근해야 하는 것도 문제이며 Build 후에야 프로퍼티가 추가된다는 문제점도 존재.
  func testLocalizableLogin() throws {
    XCTAssertEqual(I18N.L_N_LVC_TXTF_ID, NSLocalizedString("L_N_LVC_TXTF_ID", comment: ""))
    XCTAssertEqual(I18N.L_N_LVC_TXTF_PW, NSLocalizedString("L_N_LVC_TXTF_PW", comment: ""))
    XCTAssertEqual(I18N.L_N_LVC_BTN_LOGIN, NSLocalizedString("L_N_LVC_BTN_LOGIN", comment: ""))
    XCTAssertEqual(I18N.L_N_LVC_BTN_SIGNIN, NSLocalizedString("L_N_LVC_BTN_SIGNIN", comment: ""))
    XCTAssertEqual(I18N.L_N_LVC_BTN_PWRESET, NSLocalizedString("L_N_LVC_BTN_PWRESET", comment: ""))
    XCTAssertEqual(I18N.L_N_LVC_BTN_SIGNIN_OAUTH, NSLocalizedString("L_N_LVC_BTN_SIGNIN_OAUTH", comment: ""))
    XCTAssertEqual(I18N.L_N_LVC_LB_SIGN_OAUTH, NSLocalizedString("L_N_LVC_LB_SIGN_OAUTH", comment: ""))
    XCTAssertEqual(I18N.L_N_LVC_ALERT_AUTOLOGINFAIL, NSLocalizedString("L_N_LVC_ALERT_LOGINFAIL", comment: ""))
  }
}
