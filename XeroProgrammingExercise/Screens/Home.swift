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
            Home()
        }
    }
}

struct Logo: View {
    var body: some View {
        return Image("Logo").padding(20)
    }
}

struct Home: View {
    
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
        
        // This should really be a NavigationStack but I hit a problem
        // probably caused by the beta XCode I'm using. So old approach.
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
                // For real app, would need an empty-state display here
            }
        }
        .onAppear(perform: {
            viewModel.introduce(animated: !appDelegate.isPreview)
        })
        .accentColor(Color("Brand"))
    }
}

struct InvoiceList: View {
    
    @ObservedObject var model: Home.ListModel
    
    func makeSlideEffect(model: Home.InvoiceModel) -> some GeometryEffect {
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
    
    var model: Home.InvoiceModel
    
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

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct InvoiceList_Previews: PreviewProvider {
    static var previews: some View {
        InvoiceList(model: Home.ListModel())
    }
}
