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
        
        print(I18N.L_N_LVC_TXTF_ID)
    }
}
