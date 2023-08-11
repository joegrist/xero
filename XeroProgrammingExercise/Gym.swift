//
//  Gym.swift
//  XeroProgrammingExercise
//
//  Created by Joseph Grist on 10/8/2023.
//  Copyright © 2023 Xero Ltd. All rights reserved.
//

import Foundation

class Gym {
    
    static func exercise() {
        do {
            print("Doing my exercises....")
            try createInvoiceWithOneItem()
            try createInvoiceWithMultipleItemsAndQuantities() // 72.1
            try removeItem() // 41.32
            try mergeInvoices() // 65.35
            try cloneInvoice() // 25.8
            try orderLineItems() // Prints description, 3 items
            try previewLineItems() // Prints description of first item
            try removeExtraItems() // Only the orange: 5.22
            try invoiceToString() // Prints description, 1 item
            print("\n\n")
        } catch {
            print("Failed to complete exercise programme: \(error.localizedDescription)")
        }
    }
    
    private static func createInvoiceWithOneItem() throws {
        let invoice = Invoice.sample()
        
        let line = InvoiceLine(invoiceLineId: 1,
                                           description: "Pizza",
                                           quantity: 1,
                                           cost: "9.99")

        try invoice.addInvoiceLine(line)

    }
    
    private static func createInvoiceWithMultipleItemsAndQuantities() throws {
        let invoice = Invoice.sample()
        
        try invoice.addInvoiceLine(InvoiceLine(invoiceLineId: 1,
                                           description: "Banana",
                                           quantity: 4,
                                           cost: "10.21"))
        
        try invoice.addInvoiceLine(InvoiceLine(invoiceLineId: 2,
                                           description: "Orange",
                                           quantity: 1,
                                           cost: "5.21"))
        
        try invoice.addInvoiceLine(InvoiceLine(invoiceLineId: 3,
                                           description: "Pizza",
                                           quantity: 5,
                                           cost: "5.21"))
        print(invoice.total)
    }
    
    private static func removeItem() throws {
        let invoice = Invoice.sample()
        
        try invoice.addInvoiceLine(InvoiceLine(invoiceLineId: 1,
                                           description: "Orange",
                                           quantity: 1,
                                           cost: "5.22"))
        
        try invoice.addInvoiceLine(InvoiceLine(invoiceLineId: 2,
                                           description: "Banana",
                                           quantity: 4,
                                           cost: "10.33"))
        
        invoice.removeInvoiceLine(having: 1)

        print(invoice.total)
    }
    
    private static func mergeInvoices() throws {
        let invoice1 = Invoice.sample()
        

        try invoice1.addInvoiceLine(InvoiceLine(invoiceLineId: 1,
                                            description: "Banana",
                                            quantity: 4,
                                            cost: "10.33"))
        
        let invoice2 = Invoice.sample()
        
        try invoice2.addInvoiceLine(InvoiceLine(invoiceLineId: 2,
                                            description: "Orange",
                                            quantity: 1,
                                            cost: "5.22"))
        
        try invoice2.addInvoiceLine(InvoiceLine(invoiceLineId: 3,
                                            description: "Blueberries",
                                            quantity: 3,
                                            cost: "6.27"))
        
        try invoice1.appendItems(from: invoice2)

        print(invoice1.total)
        
    }
    
    private static func cloneInvoice() throws {
        let invoice = Invoice.sample()

        try invoice.addInvoiceLine(InvoiceLine(invoiceLineId: 1,
                                           description: "Apple",
                                           quantity: 1,
                                           cost: "6.99"))
        
        try invoice.addInvoiceLine(InvoiceLine(invoiceLineId: 2,
                                           description: "Blueberries",
                                           quantity: 3,
                                           cost: "6.27"))
        
        let clonedInvoice = try invoice.clone()
        print(clonedInvoice.total)
    }
    
    private static func invoiceToString() throws  {
        let invoice = Invoice.sample()

        try invoice.addInvoiceLine(InvoiceLine(invoiceLineId: 1,
                                           description: "Apple",
                                           quantity: 1,
                                           cost: "6.99"))
        print(invoice.debugDescription)
    }
    
    private static func orderLineItems() throws {
        let invoice = Invoice.sample()
        
        try invoice.addInvoiceLine(InvoiceLine(invoiceLineId: 3,
                                           description: "Banana",
                                           quantity: 4,
                                           cost: "10.21"))
        
        try invoice.addInvoiceLine(InvoiceLine(invoiceLineId: 2,
                                           description: "Orange",
                                           quantity: 1,
                                           cost: "5.21"))
        
        try invoice.addInvoiceLine(InvoiceLine(invoiceLineId: 1,
                                           description: "Pizza",
                                           quantity: 5,
                                           cost: "5.21"))

        invoice.orderLineItems()
        print(invoice.debugDescription)
    }
    
    private static func previewLineItems() throws {
        let invoice = Invoice.sample()
        
        try invoice.addInvoiceLine(InvoiceLine(invoiceLineId: 1,
                                           description: "Banana",
                                           quantity: 4,
                                           cost: "10.21"))
        
        try invoice.addInvoiceLine(InvoiceLine(invoiceLineId: 2,
                                           description: "Orange",
                                           quantity: 1,
                                           cost: "5.21"))
        
        try invoice.addInvoiceLine(InvoiceLine(invoiceLineId: 3,
                                           description: "Pizza",
                                           quantity: 5,
                                           cost: "5.21"))
            
        invoice.debugLineItems(1)
    }
    
    private static func removeExtraItems() throws {
        let invoice1 = Invoice.sample()
        
        try invoice1.addInvoiceLine(InvoiceLine(invoiceLineId: 1,
                                            description: "Banana",
                                            quantity: 4,
                                            cost: "10.33"))
        
        try invoice1.addInvoiceLine(InvoiceLine(invoiceLineId: 3,
                                            description: "Blueberries",
                                            quantity: 3,
                                            cost: "6.27"))
    
        let invoice2 = Invoice.sample()
        
        try invoice2.addInvoiceLine(InvoiceLine(invoiceLineId: 2,
                                            description: "Orange",
                                            quantity: 1,
                                            cost: "5.22"))
        
        try invoice2.addInvoiceLine(InvoiceLine(invoiceLineId: 3,
                                            description: "Blueberries",
                                            quantity: 3,
                                            cost: "6.27"))

        invoice2.removeItems(alsoPresentIn: invoice1)
        print(invoice2.total)
    }
}
