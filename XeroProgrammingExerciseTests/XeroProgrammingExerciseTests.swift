//
//  XeroProgrammingExerciseTests.swift
//  XeroProgrammingExerciseTests
//
//  Created by Francesco P on 5/05/20.
//  Copyright © 2020 Xero Ltd. All rights reserved.
//

import XCTest
@testable import XeroProgrammingExercise

class XeroProgrammingExerciseTests: XCTestCase {

    var invoice: Invoice!
    var item1 = InvoiceLine(
        invoiceLineId: 1,
        description: "Cat",
        quantity: 1,
        cost: "1.01"
    )
    var item2 = InvoiceLine(
        invoiceLineId: 2, 
        description: "Dog",
        quantity: 3,
        cost: "0.54"
    )
    var item3 = InvoiceLine(
        invoiceLineId: 3,
        description: "Rabbit",
        quantity: 3,
        cost: "194.83"
    )
    var dupe = InvoiceLine(
        invoiceLineId: 1,
        description: "Goose",
        quantity: 1, 
        cost: "12.95"
    )
    
    var list: [Int] {
        get {
            return invoice.lineItems.map{ $0.invoiceLineId }
        }
    }
    
    override func setUpWithError() throws {
        invoice = Invoice.sample()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produ10.ce the correct results.
    }
    
    func testTotal() throws {
        try invoice.addInvoiceLine(item1)
        try invoice.addInvoiceLine(item2)
        try invoice.addInvoiceLine(item3)
        XCTAssertEqual(invoice.total, 587.12)
    }
    
    func testDupe() throws {
        try invoice.addInvoiceLine(item1) // OK
        try invoice.addInvoiceLine(item2) // OK
        
        // Invalid
        XCTAssertThrowsError(
            try invoice.addInvoiceLine(dupe)
        , "Adding duplicate item should have thrown error") { error in
            if case .itemAlreadyExists(let index) = error as? InvoiceError, index == 1 {
                return
            }
            XCTFail("Adding duplicate item threw wrong error")
        }
    }
    
    func testMerge() throws {
        let other = Invoice(number: 2)
        try invoice.addInvoiceLine(item1)
        try invoice.addInvoiceLine(item2)
        try other.addInvoiceLine(item3)
        
        // This should work, no dupes
        try invoice.appendItems(from: other)
        
        XCTAssertEqual(list, [1, 2, 3])
        
        // Try again: Should fail, there's already a line item
        XCTAssertThrowsError(try invoice.appendItems(from: other))
    }
    
    func testRemove() throws {
        try invoice.addInvoiceLine(item1)
        try invoice.addInvoiceLine(item2)
        try invoice.addInvoiceLine(item3)
        invoice.removeInvoiceLine(having: item2.invoiceLineId)
        XCTAssertEqual(list, [1, 3])
    }
    
    func testClone() throws {
        try invoice.addInvoiceLine(item1)
        try invoice.addInvoiceLine(item2)
        let clone = try invoice.clone()
        XCTAssertTrue(invoice.total == clone.total)
    }
    
    func testOrder() throws {
        try invoice.addInvoiceLine(item2)
        try invoice.addInvoiceLine(item3)
        try invoice.addInvoiceLine(item1)
        XCTAssertEqual(list, [2, 3, 1])
        invoice.orderLineItems()
        XCTAssertEqual(list, [1, 2, 3])
    }
    
    func testDateFormat() {
        let importantDate = "08/01/1935" // Elvis' birthday, if you care.
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Date.standardFormat
        let date = dateFormatter.date(from: importantDate)
        XCTAssertTrue(importantDate == date?.toStandardFormat())
    }
    
    // Just going to test this doesn't crash anything
    func testPreview() throws {
        try invoice.addInvoiceLine(item1)
        try invoice.addInvoiceLine(item2)
        try invoice.addInvoiceLine(item3)
        invoice.debugLineItems(-1)
        invoice.debugLineItems(498)
        invoice.debugLineItems(2)
    }
    
    func testExclude() throws {
        try invoice.addInvoiceLine(item1)
        try invoice.addInvoiceLine(item2)
        try invoice.addInvoiceLine(item3)
        let other = Invoice(number: 2)
        try other.addInvoiceLine(item1)
        try other.addInvoiceLine(item3)
        invoice.removeItems(alsoPresentIn: other)
        XCTAssertEqual(list, [2])
    }
    
    func testCurrency() {
        let value: Decimal = 1.9
        XCTAssertEqual(value.toCurrencyFormat(), "$1.90")
        XCTAssertEqual(value.toCurrencySpokenText(), "1.90 Australian dollars")
    }
}
