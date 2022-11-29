//
//  issue_trackerUnitTest_Persistent_Setting.swift
//  issue-trackerUnitTests
//
//  Created by 백상휘 on 2022/11/28.
//

import XCTest

final class issue_trackerUnitTest_Persistent_Setting: XCTestCase {
    func test_SettingChecker() throws {
        TransformableHelper.register()
        let checkCoreData = CheckDefaultCoreData()
        checkCoreData.removeAllSettingItems()
        
        XCTAssertFalse(checkCoreData.checkDefaultData(), "SettingItems Remove Failed")
        
        checkCoreData.setDefaultSettingItems()
        
        XCTAssertTrue(checkCoreData.checkDefaultData(), "SettingItems Insert Failed")
    }
}
