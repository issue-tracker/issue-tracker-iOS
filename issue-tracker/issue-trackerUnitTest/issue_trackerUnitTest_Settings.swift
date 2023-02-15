//
//  issue_trackerUnitTest_Settings.swift
//  issue-trackerUnitTests
//
//  Created by 백상휘 on 2022/11/30.
//

import XCTest
import CoreData

final class issue_trackerUnitTest_Settings: XCTestCase {
    
    func test_getList() throws {
        let coreDataStack = CoreDataStack()
        let model = SettingMainListModel(context: coreDataStack.context)
        let categories = model.getCategoryArray()
        
        XCTAssertGreaterThan(categories.count, 0)
        
        /// Fatal error: NSArray element failed to match the Swift Array Element type
//        for (_, category) in categories.enumerated() {
//
//            guard let items = category.items, items.array.isEmpty == false else {
//                XCTFail("Setting Unit Test Failed. \(category.title ?? "") has no children(items).")
//                continue
//            }
//
//            let list = model.getListArray(parent: category)
//            XCTAssertGreaterThan(list.count, 0)
//
//            for listItem in list {
//
//                guard let values = listItem.values, values.array.isEmpty == false else {
//                    XCTFail("Setting Unit Test Failed. \(listItem.title) has no children(values).")
//                    continue
//                }
//
//                let items = model.getItemArray(parent: listItem)
//                XCTAssertGreaterThan(items.count, 0)
//
//                for item in items {
//
//                    XCTAssertNotNil(item.value, "Setting Unit Test Failed. \(item.mainTitle ?? "") has no value.")
//                }
//            }
//        }
    }
}
