//
//  issue_trackerUITests.swift
//  issue-trackerUITests
//
//  Created by 백상휘 on 2022/08/08.
//

import XCTest

class issue_trackerUITests: XCTestCase {

    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
