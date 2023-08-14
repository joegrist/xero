//
//  XeroProgrammingExerciseUITests.swift
//  XeroProgrammingExerciseUITests
//
//  Created by Francesco P on 5/05/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import XCTest
import XeroShared

// Classes representing pages are a good what to organise UI test coce
class Screen {
    internal let app: XCUIApplication
    
    init(of app: XCUIApplication) {
        self.app = app
    }
    
    var at: Bool {
        return false
    }
}

class HomeScreen: Screen {
    
    var secondInvoice: XCUIElement {
        let nav = invoices.element(boundBy: 2)
        if !nav.waitForExistence(timeout: 2) {
            XCTFail("List of invoices did not appear")
        }
        return nav
    }
    
    var invoices: XCUIElementQuery {
        return app.scrollViews.element.buttons
    }
    
    override var at: Bool {
        return app.staticTexts["Invoices"].exists
    }
}

class ListScreen: Screen {
    
    var backButton: XCUIElement {
        return app.buttons["Invoices"]
    }
    
    override var at: Bool{
        return backButton.exists
    }
}

class XeroProgrammingExerciseUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func launch() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments.append(XeroShared.Config.TEST_ARGUMENT)
        app.launch()
        //print(app.debugDescription)
        return app
    }
    
    // Does it launch OK?
    func testLaunch() throws {
        let app = launch()
        let home = HomeScreen(of: app)
        XCTAssert(home.at)
    }
    
    // First screen contains valid data
    func testFirstScreenContents() throws {
        let app = launch()
        let home = HomeScreen(of: app)
        XCTAssertTrue(home.invoices.count == 3)
        XCTAssertTrue(home.invoices.element(boundBy: 0).label.contains("41.32"))
        XCTAssertTrue(home.invoices.element(boundBy: 1).label.contains("24.03"))
        XCTAssertTrue(home.invoices.element(boundBy: 2).label.contains("9.99"))
    }

    // Can navigate in and out of second screen
    func testNavigation() throws {
        let app = launch()
        let home = HomeScreen(of: app)
        let list = ListScreen(of: app)
        XCTAssert(home.at)
        home.secondInvoice.tap()
        XCTAssert(list.at)
        list.backButton.tap()
        XCTAssert(home.at)
    }
    
    func testInvoiceDetails() {
        let app = launch()
        let home = HomeScreen(of: app)
        let list = ListScreen(of: app)
        home.secondInvoice.tap()
        XCTAssert(list.at)
    }
}
