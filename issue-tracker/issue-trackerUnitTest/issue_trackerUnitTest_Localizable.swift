//
//  issue_trackerUnitTest_Localizable.swift
//  issue-trackerUnitTests
//
//  Created by 백상휘 on 2022/12/13.
//

import XCTest

final class issue_trackerUnitTest_Localizable: XCTestCase {
    func testLocalizableLogin() throws {
      XCTAssertEqual(I18N.L_N_LVC_TXTF_ID, NSLocalizedString("L_N_LVC_TXTF_ID", comment: ""))
      XCTAssertEqual(I18N.L_N_LVC_TXTF_PW, NSLocalizedString("L_N_LVC_TXTF_PW", comment: ""))
      XCTAssertEqual(I18N.L_N_LVC_BTN_LOGIN, NSLocalizedString("L_N_LVC_BTN_LOGIN", comment: ""))
      XCTAssertEqual(I18N.L_N_LVC_BTN_SIGNIN, NSLocalizedString("L_N_LVC_BTN_SIGNIN", comment: ""))
      XCTAssertEqual(I18N.L_N_LVC_BTN_PWRESET, NSLocalizedString("L_N_LVC_BTN_PWRESET", comment: ""))
      XCTAssertEqual(I18N.L_N_LVC_BTN_SIGNIN_OAUTH, NSLocalizedString("L_N_LVC_BTN_SIGNIN_OAUTH", comment: ""))
      XCTAssertEqual(I18N.L_N_LVC_LB_SIGN_OAUTH, NSLocalizedString("L_N_LVC_LB_SIGN_OAUTH", comment: ""))
    }
}
