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
    @State private var selectedOffering: Offerings?
    @State var userProfile: UserProfile?
    
    func performPurchase(offering: Offerings) {
        if self.userProfile != nil {
            paymentStore.isLoading = true
            paymentStore.preparePayment(uid: self.userProfile!.uid, amount: offering.price, currency: "cad")
            paymentStore.isLoading.toggle()
        } else {
            print("You are not logged in") //add timer or something
        }
    }
    // TODO: there is a better way to do this. Figure out how to save the current logged in user from the login function in the uservm.
    // Look into the @EnviornmentState thing
    // this function is needed here to get the profile available in this view
    func fetchProfile() {
        userVM.fetchProfile() { (profile, error) in
            if let error = error {
                print("Error logging in: \(error)")
                return
            }
            self.userProfile = profile
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
            self.fetchProfile()
        }
    }
}



//struct OfferingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        OfferingsView(offering: Offerings)
//    }
//}
