//
//  ViewModel.swift
//  XeroProgrammingExercise
//
//  Created by Joseph Grist on 10/8/2023.
//  Copyright © 2023 Xero Ltd. All rights reserved.
//

import Foundation
import UIKit

extension Home {
    
    /** UI state for individual invoices */
    class InvoiceModel {
        
        var invoice: Invoice
        var hidden: Bool = true
        
        init(invoice: Invoice) {
            self.invoice = invoice
        }
    }

    /** UI state for the list of invoices */
    @MainActor class ListModel: ObservableObject {
        
        // FIXME: Should be somewhere with lifecycle matching app, like Core Data or similar
        @Published var invoices: [InvoiceModel] = []

        init() {
            let list = Api.getInvoices()
            invoices = list.map{InvoiceModel(invoice: $0)}
            Api.debug(invoices: list)
        }
        
        /**
         * Activate list row animation on presentatom
         * Works OK for mini-app
         * For realsies, would have to make sure it only applies to the first screenful
         * Also make sure only runs on first data display from empty
         */
        func introduce(animated: Bool) {
            
            guard animated else {
                invoices.forEach{ $0.hidden = true }
                objectWillChange.send()
                return
            }
            
            var delay: TimeInterval = 0
            invoices.forEach { model in
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: { [unowned self] in
                    model.hidden = false
                    objectWillChange.send()
                })
                if delay < 1 {
                    delay += 0.2
                }
            }
        }
    }
}
