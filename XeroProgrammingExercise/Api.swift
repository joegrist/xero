//
//  Api.swift
//  XeroProgrammingExercise
//
//  Created by Joseph Grist on 10/8/2023.
//  Copyright © 2023 Xero Ltd. All rights reserved.
//

import Foundation

class Api {
    
    static func getInvoices() -> [Invoice] {
        let invoice1 = Invoice(number: 1)
        
        do {
            try invoice1.addInvoiceLine(InvoiceLine(invoiceLineId: 1,
                                                    description: "Banana",
                                                    quantity: 4,
                                                    cost: "10.33"))
        } catch {
            
        }
        
        let invoice2 = Invoice(number: 2)
        
        do {
            try invoice2.addInvoiceLine(InvoiceLine(invoiceLineId: 1,
                                                    description: "Orange",
                                                    quantity: 1,
                                                    cost: "5.22"))
            
            try invoice2.addInvoiceLine(InvoiceLine(invoiceLineId: 2,
                                                    description: "Blueberries",
                                                    quantity: 3,
                                                    cost: "6.27"))
        } catch {
            
        }
        let
        invoice3 = Invoice(number: 3)
        
        do {
            try invoice3.addInvoiceLine(InvoiceLine(invoiceLineId: 1,
                                                    description: "Pizza",
                                                    quantity: 1,
                                                    cost: "9.99"))
        } catch {
            
        }
        
        return [invoice1, invoice2, invoice3]
    }
    
    static func debug(invoices: [Invoice]) {
        print("My invoice list is....")
        invoices.forEach{
            print("-----")
            print($0.debugDescription)
            $0.debugLineItems(10)
        }
    }
}
