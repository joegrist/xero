//
//  Main.swift
//  XeroProgrammingExercise
//
//  Created by Joseph Grist on 10/8/2023.
//  Copyright © 2023 Xero Ltd. All rights reserved.
//

import SwiftUI

@main
struct SampleApp: App {
    var body: some Scene {
        WindowGroup {
            Main()
        }
    }
}

/**
 * Fancy slide-in animation for list rows
 */
struct SlideEffect: GeometryEffect {
    
    var y: CGFloat = 0

    var animatableData: CGFloat {
        get { return y }
        set { y = newValue }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        return ProjectionTransform(CGAffineTransform(translationX: 0, y: y * 20))
    }
}

struct Logo: View {
    var body: some View {
        return Image("Logo").padding(20)
    }
}

struct Main: View {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @StateObject private var viewModel = ListModel()
    
    init() {
        // I've hacked the main list in this mini-app to always have
        // a dark green background.  So we need to make sure the title
        // text is always white for contrast, ignoring dark/light mode.
        // This is not ideal, as the detail view's navigation title
        // becomes white-on-while, so I've had to mock it.
        // Would need to be done better in a real app.
        appDelegate.paintNavigationTitle(textColor: UIColor.white)
    }
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("Brand").ignoresSafeArea()
                VStack {
                    Spacer()
                    Logo()
                        .foregroundColor(.white)
                        .accessibilityHidden(true)
                }
                ScrollView {
                    InvoiceList(model: viewModel)
                        .padding([.leading, .trailing])
                }
                .navigationTitle("Invoices")
                // For real app, would need an empty view here
            }
        }
        .onAppear(perform: {
            viewModel.introduce(animated: !appDelegate.isPreview)
        })
        .accentColor(Color("Brand"))
    }
}

struct InvoiceList: View {
    
    @ObservedObject var model: Main.ListModel
    
    func makeSlideEffect(model: Main.InvoiceModel) -> some GeometryEffect {
      return SlideEffect(
        y: model.hidden ? 1 : 0)
    }
    
    var body: some View {
        LazyVStack(alignment: .center) {
            ForEach(model.invoices, id: \.invoice.id) { model in
                NavigationLink(destination: InvoiceView(model: model.invoice)) {
                     InvoiceCard(model: model)
                        .foregroundColor(Color(UIColor.label))
                        .padding()
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(5)
                        .shadow(color: Color(UIColor.label.withAlphaComponent(0.3)), radius: 5)
                        .opacity(model.hidden ? 0 : 1)
                        .modifier(makeSlideEffect(model: model))
                        .animation(.easeInOut, value: model.hidden)
                }
            }
            .frame(maxWidth: 600) // Readable width, more or less
        }
    }
}

struct InvoiceCard: View {
    
    var model: Main.InvoiceModel
    
    var body: some View {
        HStack(alignment: .center) {
            Text("\(model.invoice.number)").font(.title).foregroundColor(Color("Brand"))
                .accessibilityLabel("Number \(model.invoice.number)")
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(model.invoice.formattedDate)")
                    .font(.footnote)
                    .accessibilityHidden(true)
                Text("\(model.invoice.formattedTotal)")
                    .accessibilityLabel(model.invoice.speakableTotal)
            }
            Image(systemName: "chevron.right.circle.fill").foregroundColor(Color("Brand"))
        }
        .frame(maxWidth: .infinity)
    }
}

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

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}

struct InvoiceList_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceList(model: Main.ListModel())
    }
}

struct InvoiceView_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceView(model: Main.ListModel().invoices.first!.invoice)
    }
}
