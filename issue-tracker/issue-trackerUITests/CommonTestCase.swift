//
//  CommonTestCase.swift
//  issue-trackerUITests
//
//  Created by 백상휘 on 2022/09/03.
//

import XCTest

class CommonTestCase: XCTestCase {
    var app: XCUIApplication!
    
    init(app: XCUIApplication) {
        super.init(invocation: nil)
        self.app = app
    }
    
    func prepareEachTest() { }
    func tearDownEachTest() { }
    
    func doVisibleTest() { prepareEachTest() }
    func doFunctionTest() { prepareEachTest() }
    
    func takeScreenshot(named name: String) {
        // Take the screenshot
        let fullScreenshot = XCUIScreen.main.screenshot()
        
        // Create a new attachment to save our screenshot
        // and give it a name consisting of the "named"
        // parameter and the device name, so we can find
        // it later.
        let screenshotAttachment = XCTAttachment(
            uniformTypeIdentifier: "public.png",
            name: "Screenshot-\(UIDevice.current.name)-\(name).png",
            payload: fullScreenshot.pngRepresentation,
            userInfo: nil)
            
        // Usually Xcode will delete attachments after
        // the test has run; we don't want that!
        screenshotAttachment.lifetime = .keepAlways
        
        // Add the attachment to the test log,
        // so we can retrieve it later
        add(screenshotAttachment)
    }
}
