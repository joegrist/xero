//
//  Detail.swift
//  XeroProgrammingExercise
//
//  Created by Joseph Grist on 14/8/2023.
//  Copyright © 2023 Xero Ltd. All rights reserved.
//

import Foundation
import SwiftUI

struct InvoiceView: View {
    var model: Invoice
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Logo()
                    .foregroundColor(Color("Brand"))
                    .accessibilityHidden(true)
            }
            ScrollView {
                VStack(alignment: .leading) {
                    // Hmm. Faking a navigation header.
                    // Not good.  SwiftUI not letting me change the colour here on an actual one,
                    // comes up white.
                    // Would have to do better in a real app.
                    Text("Invoice \(model.number)").font(.largeTitle).bold()
                        .padding([.bottom])
                    HStack(alignment: .firstTextBaseline) {
                        Text(model.formattedTotal).foregroundColor(Color("Brand")).font(.title)
                            .accessibilityLabel(model.speakableTotal)
                        Spacer()
                        Text(model.formattedDate)
                            .font(.footnote)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(.isSummaryElement)
                    Divider()
                    VStack(alignment: .leading) {
                        ForEach(model.lineItems) { item in
                            InvoiceLineView(model: item)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel("Line Items")
                    Spacer()
                }
                // Limit width so it doesn't look stupid wide on
                // big devices like iPads.
                .frame(maxWidth: 600)
            }
            .padding()
            .accessibilityElement(children: .contain)
        }
       
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InvoiceLineView: View {
    var model: InvoiceLine
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
                Text(model.description).bold()
                Text("\(model.quantity) @ \(model.formattedCost)")
            }
            Spacer()
            Text(model.formattedTotal)
                .font(.title2)
                .accessibilityLabel(model.speakableTotal)
        }
        .accessibilityElement(children: .combine)
        Divider()
    }
}

struct InvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceView(model: Home.ListModel().invoices.first!.invoice)
    }
}
