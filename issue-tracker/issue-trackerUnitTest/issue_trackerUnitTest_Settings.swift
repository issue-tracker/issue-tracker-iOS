//
//  issue_trackerUnitTest_Settings.swift
//  issue-trackerUnitTests
//
//  Created by 백상휘 on 2022/11/30.
//

import XCTest

final class issue_trackerUnitTest_Settings: XCTestCase {
    func test_getList() throws {
        let mainListModel = SettingMainListModel()
        
        let generalInfo = mainListModel.getMainItems[0]
        let allListInfo = mainListModel.getMainItems[1]
        
        let generalInfoSubList = mainListModel.getList(generalInfo.id)
        let allListInfoSubList = mainListModel.getList(allListInfo.id)
        
        XCTAssertEqual(generalInfoSubList.count, 2)
        
        XCTAssertEqual(allListInfoSubList.count, 3)
        
        for list in generalInfoSubList {
            XCTAssertEqual(generalInfoSubList, mainListModel.getList(list.parentId))
        }
        
        for list in allListInfoSubList {
            XCTAssertEqual(allListInfoSubList, mainListModel.getList(list.parentId))
        }
    }
}
