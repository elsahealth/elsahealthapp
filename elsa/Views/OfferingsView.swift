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
    @ObservedObject var paymentStore = PaymentStoreViewModel()
    @ObservedObject var userVM = UserProfileViewModel()
    @EnvironmentObject var userProfileWrapper : UserProfileWrapper
    @State private var selectedOffering: Offerings?
    
    func performPurchase(offering: Offerings) {
        print("Offerings view: \(self.userProfileWrapper.userProfile!)")
        if self.userProfileWrapper.userProfile != nil {
            paymentStore.isLoading = true
            paymentStore.preparePayment(uid: self.userProfileWrapper.userProfile!.uid, amount: offering.price, currency: "cad")
            paymentStore.isLoading.toggle()
        } else {
            print("You are not logged in") //add timer or something
        }
    }
    
    var body: some View {
        VStack {
            ScrollView(content: {
                LazyVGrid(columns: columns, spacing : 15, content: {
                    ForEach(viewModel.offerings, id: \.id) { item in
                            // When user selects the product that they want, prepare for payment via Stripe
                        Button(action: {
                            self.selectedOffering = item
                            performPurchase(offering: item)
                        }, label: {
                            OfferingsItemView(offering: item)
                        })
                            // when item is selected, present sheet to confirm and to buy time for the Stripe processing
                            // TODO: add loading bar/wheel
                        .sheet(item: self.$selectedOffering) { item in
                            ConfirmOfferingView(paymentStore: paymentStore, offering: item)
                        }
                    }
                })
            })
        }.onAppear() {
            self.viewModel.fetchData()
        }
    }
}



struct OfferingsView_Previews: PreviewProvider {
    static var previews: some View {
        OfferingsView()
    }
}
