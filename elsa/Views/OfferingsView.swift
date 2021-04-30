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
            // TODO: fix the implementation. I want to see a list of all the possible options then select the one that I want to buy
//            ForEach(viewModel.offerings, id: \.id) { item in
//                NavigationLink(destination: PaymentView(offering: item)) {
//                    LazyVGrid(columns: gridLayout, spacing : 15, content: {
//                        OfferingsItemView(offering: item)
//                    })
//                }
//            }
            // TODO: to be deleted once I get the above working
            List(viewModel.offerings) { offerings in
                VStack(alignment: .leading) {
                    Text(offerings.name)
                        .font(.headline)
                    Text(offerings.description)
                        .font(.caption)
                    Text("Price is: \(offerings.formattedPrice)")
                        .font(.caption)
                }
            }.onAppear() {
                self.viewModel.fetchData()
            }
        }
    }
}

//struct OfferingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        OfferingsView(offering: Offerings)
//    }
//}
