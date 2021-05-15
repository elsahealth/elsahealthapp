//
//  ConfirmOfferingView.swift
//  elsa
//
//  Created by Dusan Boskovic on 2021-05-13.
//

import SwiftUI
import Stripe
import SDWebImageSwiftUI

struct ConfirmOfferingView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var paymentStore : PaymentStore
    let offering : Offerings
    
    var body: some View {
        VStack {
            HStack {
                //Offering Photo
                WebImage(url: offering.photo)
                    .resizable()
                    .scaledToFit()
                    .padding(10)
                VStack {
                    // Offering Name
                    Text(offering.name)
                      .font(.title3)
                      .fontWeight(.black)
                    
                    // Offering Description
                    Text(offering.description)
                        .font(.body)
                        .fontWeight(.black)
                }
            }
            
            //Offering Price
            Text(offering.formattedPrice)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
        }.onTapGesture {
            presentationMode.wrappedValue.dismiss()
        }
        
        
        if let paymentSheet = paymentStore.paymentSheet {
            PaymentSheet.PaymentButton (
                paymentSheet: paymentSheet,
                onCompletion: paymentStore.onPaymentCompletion
            ) {
                Text("Confirm Purchase")
            }.disabled(paymentStore.paymentResult != nil)
        }
        
        // Unpack the result from the payment, and produce output
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
}

//struct ConfirmOfferingView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfirmOfferingView(paymentStore: PaymentStore, offering: offering[0])
//    }
//}
