//
//  XeroProgrammingExerciseUITests.swift
//  XeroProgrammingExerciseUITests
//
//  Created by Francesco P on 5/05/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import XCTest

class XeroProgrammingExerciseUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        print(app.debugDescription)
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(app.staticTexts["Invoices"].exists)
        let invoices = app.scrollViews.element.buttons
        XCTAssertTrue(invoices.count == 3)
        XCTAssertTrue(invoices.element(boundBy: 0).label.contains("41.32"))
        XCTAssertTrue(invoices.element(boundBy: 1).label.contains("24.03"))
        XCTAssertTrue(invoices.element(boundBy: 2).label.contains("9.99"))
    }

}
