//
//  ViewModel.swift
//  XeroProgrammingExercise
//
//  Created by Joseph Grist on 10/8/2023.
//  Copyright © 2023 Xero Ltd. All rights reserved.
//

import Foundation

extension Main {
    
    class InvoiceModel {
        
        var invoice: Invoice
        var hidden: Bool = false
        
        init(invoice: Invoice) {
            self.invoice = invoice
        }
    }
    
    @MainActor class ViewModel: ObservableObject {
        
        @Published var invoices: [InvoiceModel] = []

        init() {
            let list = Api.getInvoices()
            invoices = list.map{InvoiceModel(invoice: $0)}
            Api.debug(invoices: list)
        }
        
        /**
         * Activate list row animation on presentatom
         * Works OK for mini-app
         * For realsies, would have to make sure it only applies to the first screenload
         * And only runs on first data fetch from empty
         */
        func animate() {
            
            // Ignore in Xcode
            guard !isPreview else { return }
            
            invoices.forEach{ $0.hidden = true }
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
