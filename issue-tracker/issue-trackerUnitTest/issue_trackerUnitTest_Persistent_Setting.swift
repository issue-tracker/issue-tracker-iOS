//
//  issue_trackerUnitTest_Persistent_Setting.swift
//  issue-trackerUnitTests
//
//  Created by 백상휘 on 2022/11/28.
//

import XCTest

final class issue_trackerUnitTest_Persistent_Setting: XCTestCase {
  
  let stack = CoreDataStack()
  
  func test_SettingChecker() throws {
    SettingValueTransformable.register()
    
    stack.removeAllSettingLists()
    
    do {
      var count = 0
      
      count = try stack.context.count(for: SettingCategory.fetchRequest())
      XCTAssertEqual(count, 0)
      
      count = try stack.context.count(for: SettingListItem.fetchRequest())
      XCTAssertEqual(count, 0)
      
      count = try stack.context.count(for: SettingList.fetchRequest())
      XCTAssertEqual(count, 0)
      
    } catch let error as NSError {
      print("Error occured \(error), \(error.userInfo)")
    }
    
    stack.resetDefaultSetting()
    
    XCTAssertTrue(stack.checkSettingListAvailable())
  }
}
