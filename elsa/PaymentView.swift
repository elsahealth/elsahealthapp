//
//  PaymentView.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-04-07.
//

import SwiftUI
import Stripe

struct PaymentView: View {
    @ObservedObject var paymentStore = PaymentStore()
    @ObservedObject var sessionStore = SessionStore()
    
    let offering: Offerings
    
    func getUser() {
        sessionStore.listen()
    }
    
    var body: some View {
        VStack {
            if let user = sessionStore.user {
                VStack {
                    if let paymentSheet = paymentStore.paymentSheet {
                        PaymentSheet.PaymentButton (
                            paymentSheet: paymentSheet,
                            onCompletion: paymentStore.onPaymentCompletion
                        ) {
                            Text("Buy!")
                        }.disabled(paymentStore.paymentResult != nil)
                    } else {
                        Button("Start") {
                            paymentStore.preparePayment(uid: user.uid, amount: offering.price, currency: "cad")
                        }.disabled(paymentStore.isLoading)
                    }
                    if let result = paymentStore.paymentResult {
                        VStack {
                            switch result {
                            case .completed (let pi):
                                Text("Payment complete: (\(pi.stripeId))")
                            case .failed (let error, _):
                                Text("Payment failed: \(error.localizedDescription)")
                            case .canceled (_):
                                Text("Payment cancelled")
                            }
                        }
                    }
                }
//            } else {
//                //loginview
            }
        }.onAppear(perform: getUser)
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView(offering: offering[0])
    }
}
