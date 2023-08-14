//
//  Screens.swift
//  XeroProgrammingExerciseUITests
//
//  Created by Joseph Grist on 14/8/2023.
//  Copyright © 2023 Xero Ltd. All rights reserved.
//

import Foundation
import XCTest

// Classes representing pages are a good way to organise UI test code
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
        let nav = invoices.element(boundBy: 1)
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
