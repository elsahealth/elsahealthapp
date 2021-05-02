//
//  OfferingsView.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-03-17.
//

import SwiftUI
import Stripe

struct OfferingsView: View {
    @ObservedObject var viewModel = OfferingsViewModel()
    
    var body: some View {
        VStack {
            ScrollView(content: {
                LazyVGrid(columns: columns, spacing : 15, content: {
                    ForEach(viewModel.offerings, id: \.id) { item in
                        NavigationLink(destination: PaymentView(offering: item)) {
                            OfferingsItemView(offering: item)
                        }
                    }
                })
            })
            }.onAppear() {
                self.viewModel.fetchData()
        }
    }
}

//struct OfferingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        OfferingsView(offering: Offerings)
//    }
//}
